//
//  albumModel.swift
//  Bassic
//
//  Created by Andrew Sowers on 2/21/15.
//  Copyright (c) 2015 Andrew Sowers. All rights reserved.
//

import Foundation

class albumModel : playlistModel {
    var albumName:String = String()
    var albumArtist:String = String()
    var albumYear:String = String()

    init(){
        
        super.init(name:String(), list: [Song]())
    }
    func setAlbumName(name:String){
        
    }
}