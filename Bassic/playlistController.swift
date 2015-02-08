//
//  playlistController.swift
//  Bassic
//
//  Created by Andrew Sowers on 2/3/15.
//  Copyright (c) 2015 Andrew Sowers. All rights reserved.
//

import Foundation

class playlistController: NSObject {
    
    var playlistDict:[String: playlistModel] = ["All songs":playlistModel(name: "All songs",list: [])]
    
    func addPlaylist(name:String) -> Bool {
        if (playlistDict[name]==nil){
            playlistDict[name] = playlistModel(name: name, list: [])
            return true
        }
        return false
    }
    
    func removePlaylist(name:String) -> Bool {
        if (playlistDict[name] != nil && playlistDict[name] != "All songs") {
            playlistDict[name] = nil
            return true
        }
        return false
    }
    
    func accessPlaylist(name:String)->playlistModel {
        return playlistDict[name]!
    }
    
    func getPlaylistList() -> [String] {
        let sortedKeys = Array(playlistDict.keys).sorted(<)
        return sortedKeys
    }
    
    func addSongToPlaylist(playlistName:String, songTitle:String, songArtist:String, songAlbum:String, songLength:Float, songYear:Int, songComposer:String) -> Bool {

        var song:songModel = songModel(title: songTitle, artist: songArtist, album: songAlbum, length: songLength, year: songYear, composer: songComposer)
        playlistDict[playlistName]?.add(song)
        return true
    }
    
    func referenceSongFromPLaylistToPlaylist(sourcePLaylistName:String,destPlaylistName:String,songName:String) -> Bool{
        let sourcePlaylist = playlistDict[sourcePLaylistName]
        let destPlaylist   = playlistDict[destPlaylistName]
        if let song:songModel = sourcePlaylist?.accessSongByTitle(songName) as songModel! {
            destPlaylist?.add(song)
            return true
        }
        return false
    }
}