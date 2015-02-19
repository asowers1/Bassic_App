//
//  SharedPlaylistController.swift
//  Bassic
//
//  Created by Andrew Sowers on 2/19/15.
//  Copyright (c) 2015 Andrew Sowers. All rights reserved.
//

import Foundation

private let _sharedPlaylistController:playlistController = playlistController()

class SharedPlaylistController: NSObject {
    class var sharedInstance: playlistController {
        return _sharedPlaylistController
    }
}
