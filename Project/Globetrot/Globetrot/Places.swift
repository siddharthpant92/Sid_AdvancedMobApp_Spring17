//
//  Places.swift
//  Globetrot
//
//  Created by Siddharth on 2/28/17.
//  Copyright © 2017 Siddharth. All rights reserved.
//

import Foundation
import RealmSwift

class Places: Object
{
    dynamic var placeName = String()
    dynamic var mainNotes = String()
    dynamic var extraNotes = String()
    dynamic var placeImageName = String()
}

