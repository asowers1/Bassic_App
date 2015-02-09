//
//  songModel.swift
//  Bassic
//
//  Created by Andrew Sowers on 2/3/15.
//  Copyright (c) 2015 Andrew Sowers. All rights reserved.
//

import Foundation
import UIKit

class songModel: NSObject {
    var title:String     = ""
    var artist:String    = ""
    var album:String     = ""
    var length:String    = ""
    var year:String         = ""
    var composer:String  = ""
    
    init(title:String, artist:String, album:String, length:String, year:String, composer:String) {
        self.title    = title
        self.artist   = artist
        self.album    = album
        self.length   = length
        self.year     = year
        self.composer = composer
    }
    
    
}