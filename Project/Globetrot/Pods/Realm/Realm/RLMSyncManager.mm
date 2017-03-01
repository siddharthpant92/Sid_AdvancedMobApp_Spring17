////////////////////////////////////////////////////////////////////////////
//
// Copyright 2016 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

#import "RLMSyncManager_Private.h"

#import "RLMRealmConfiguration+Sync.h"
#import "RLMSyncConfiguration_Private.hpp"
#import "RLMSyncSession_Private.hpp"
#import "RLMSyncUser_Private.hpp"
#import "RLMUtil.hpp"

#import "sync/sync_config.hpp"
#import "sync/sync_manager.hpp"
#import "sync/sync_session.hpp"

using namespace realm;
using Level = realm::util::Logger::Level;

namespace {

Level levelForSyncLogLevel(RLMSyncLogLevel logLevel) {
    switch (logLevel) {
        case RLMSyncLogLevelOff:    return Level::off;
        case RLMSyncLogLevelFatal:  return Level::fatal;
        case RLMSyncLogLevelError:  return Level::error;
        case RLMSyncLogLevelWarn:   return Level::warn;
        case RLMSyncLogLevelInfo:   return Level::info;
        case RLMSyncLogLevelDetail: return Level::detail;
        case RLMSyncLogLevelDebug:  return Level::debug;
        case RLMSyncLogLevelTrace:  return Level::trace;
        case RLMSyncLogLevelAll:    return Level::all;
    }
    REALM_UNREACHABLE();    // Unrecognized log level.
}

RLMSyncLogLevel logLevelForLevel(Level logLevel) {
    switch (logLevel) {
        case Level::off:    return RLMSyncLogLevelOff;
        case Level::fatal:  return RLMSyncLogLevelFatal;
        case Level::error:  return RLMSyncLogLevelError;
        case Level::warn:   return RLMSyncLogLevelWarn;
        case Level::info:   return RLMSyncLogLevelInfo;
        case Level::detail: return RLMSyncLogLevelDetail;
        case Level::debug:  return RLMSyncLogLevelDebug;
        case Level::trace:  return RLMSyncLogLevelTrace;
        case Level::all:    return RLMSyncLogLevelAll;
    }
    REALM_UNREACHABLE();    // Unrecognized log level.
}

struct CocoaSyncLogger : public realm::util::RootLogger {
    void do_log(Level, std::string message) override {
        NSLog(@"Sync: %@", RLMStringDataToNSString(message));
    }
};

struct CocoaSyncLoggerFactory : public realm::SyncLoggerFactory {
    std::unique_ptr<realm::util::Logger> make_logger(realm::util::Logger::Level level) override {
        auto logger = std::make_unique<CocoaSyncLogger>();
        logger->set_level_threshold(level);
        return std::move(logger);
    }
} s_syncLoggerFactory;

} // anonymous namespace

@interface RLMSyncManager ()
- (instancetype)initWithCustomRootDirectory:(nullable NSURL *)rootDirectory NS_DESIGNATED_INITIALIZER;
@end

@implementation RLMSyncManager

static RLMSyncManager *s_sharedManager = nil;
static dispatch_once_t s_onceToken;

+ (instancetype)sharedManager {
    dispatch_once(&s_onceToken, ^{
        s_sharedManager = [[RLMSyncManager alloc] initWithCustomRootDirectory:nil];
    });
    return s_sharedManager;
}

- (instancetype)initWithCustomRootDirectory:(NSURL *)rootDirectory {
    if (self = [super init]) {
        // Initialize the sync engine.
        SyncManager::shared().set_logger_factory(s_syncLoggerFactory);
        bool should_encrypt = !getenv("REALM_DISABLE_METADATA_ENCRYPTION") && !RLMIsRunningInPlayground();
        auto mode = should_encrypt ? SyncManager::MetadataMode::Encryption : SyncManager::MetadataMode::NoEncryption;
        rootDirectory = rootDirectory ?: [NSURL fileURLWithPath:RLMDefaultDirectoryForBundleIdentifier(nil)];
        SyncManager::shared().configure_file_system(rootDirectory.path.UTF8String, mode, none, true);
        return self;
    }
    return nil;
}

- (NSString *)appID {
    if (!_appID) {
        _appID = [[NSBundle mainBundle] bundleIdentifier] ?: @"(none)";
    }
    return _appID;
}

#pragma mark - Passthrough properties

- (RLMSyncLogLevel)logLevel {
    return logLevelForLevel(realm::SyncManager::shared().log_level());
}

- (void)setLogLevel:(RLMSyncLogLevel)logLevel {
    realm::SyncManager::shared().set_log_level(levelForSyncLogLevel(logLevel));
}

- (BOOL)disableSSLValidation {
    return realm::SyncManager::shared().client_should_validate_ssl();
}

- (void)setDisableSSLValidation:(BOOL)disableSSLValidation {
    realm::SyncManager::shared().set_client_should_validate_ssl(!disableSSLValidation);
}

#pragma mark - Private API

- (void)_fireError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.errorHandler) {
            self.errorHandler(error, nil);
        }
    });
}

- (void)_fireErrorWithCode:(int)errorCode
                   message:(NSString *)message
                   isFatal:(BOOL)fatal
                   session:(RLMSyncSession *)session
                  userInfo:(NSDictionary *)userInfo
                errorClass:(RLMSyncSystemErrorKind)errorClass {
    NSError *error = nil;
    NSMutableDictionary *mutableUserInfo = [userInfo mutableCopy];
    mutableUserInfo[@"description"] = message;
    mutableUserInfo[@"error"] = @(errorCode);
    mutableUserInfo[@"underlying_class"] = @(errorClass);

    switch (errorClass) {
        case RLMSyncSystemErrorKindClientReset: {
            // Client reset is a special case; the application can respond to it to a greater degree than
            // it can for most other errors.
            mutableUserInfo[kRLMSyncPathOfRealmBackupCopyKey] = userInfo[@(realm::SyncError::c_recovery_file_path_key)];
            std::string original_path = [userInfo[@(realm::SyncError::c_original_file_path_key)] UTF8String];
            mutableUserInfo[kRLMSyncInitiateClientResetBlockKey] = ^{
                SyncManager::shared().immediately_run_file_actions(original_path);
            };
            error = [NSError errorWithDomain:RLMSyncErrorDomain
                                        code:RLMSyncErrorClientResetError
                                    userInfo:mutableUserInfo];
            break;
        }
        case RLMSyncSystemErrorKindUser:
            error = [NSError errorWithDomain:RLMSyncErrorDomain
                                        code:RLMSyncErrorClientUserError
                                    userInfo:mutableUserInfo];
            break;
        case RLMSyncSystemErrorKindSession:
            error = [NSError errorWithDomain:RLMSyncErrorDomain
                                        code:RLMSyncErrorClientSessionError
                                    userInfo:mutableUserInfo];
            break;
        case RLMSyncSystemErrorKindConnection:
        case RLMSyncSystemErrorKindClient:
            // Report the error. There's nothing the user can do about it, though.
            if (fatal) {
                error = [NSError errorWithDomain:RLMSyncErrorDomain
                                            code:RLMSyncErrorClientInternalError
                                        userInfo:mutableUserInfo];
            }
            break;
        case RLMSyncSystemErrorKindUnknown:
            break;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.errorHandler || !error) {
            return;
        }
        self.errorHandler(error, session);
    });
}

- (NSArray<RLMSyncUser *> *)_allUsers {
    NSMutableArray<RLMSyncUser *> *buffer = [NSMutableArray array];
    for (auto user : SyncManager::shared().all_logged_in_users()) {
        [buffer addObject:[[RLMSyncUser alloc] initWithSyncUser:std::move(user)]];
    }
    return buffer;
}

+ (void)resetForTesting {
    SyncManager::shared().reset_for_testing();
}

@end
