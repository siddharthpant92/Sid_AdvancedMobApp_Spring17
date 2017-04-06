//
//  teamPlayer.swift
//  lab_6
//
//  Created by Siddharth on 4/5/17.
//  Copyright © 2017 Siddharth. All rights reserved.
//

import Foundation
import Firebase

class teamPlayer
{
    var team: String
    var player: String
    var position: String
    
    init(newTeam: String, newPlayer: String, newPosition: String)
    {
        team = newTeam
        player = newPlayer
        position = newPosition
    }
    
    init(snapshot: FIRDataSnapshot)
    {
        let snapshotValue = snapshot.value as! [String: String]
        team = snapshotValue["team"]!
        player = snapshotValue["name"]!
        position = snapshotValue["position"]!
    }
}
