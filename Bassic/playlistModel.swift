//
//  playlistModel.swift
//  Bassic
//
//  Created by Andrew Sowers on 2/3/15.
//  Copyright (c) 2015 Andrew Sowers. All rights reserved.
//

import Foundation
import UIKit

class playlistModel: NSObject {
    var name: String
    var list: [songModel] = []
    
    init(name:String, list: [songModel]) {
        self.name = name
        self.list = list
    }
    
    func add(newSong:songModel){
        list.append(newSong)
        list.sort({ $0.title < $1.title })
    }
    func remove(toRemove:Int){
        list.removeAtIndex(toRemove)
        list.sort({ $0.title < $1.title })
    }
    func listAllSongs()->[String]{
        var allSong: [String] = []
        for i in list{
            allSong.append(i.title)
        }
        return allSong
    }
    func listArtistSong(artist:String)->[String]{
        var artistList: [String] = []
        for i in list{
            if(artist == i.artist){
                artistList.append(i.title)
            }
        }
        return artistList
    }
    func accessSong(index:Int) -> songModel? {
        return index >= list.count ? nil : list[index]
    }
    
    func accessSongByTitle(title:String) -> songModel?{
        for song in list {
            if song.title == title {
                return song
            }
        }
        return nil
    }
}