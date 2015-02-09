//
//  playlistModel.swift
//  Bassic
//
//  Created by Andrew Sowers on 2/3/15.
//  Copyright (c) 2015 Andrew Sowers. All rights reserved.
//

import Foundation
import UIKit


//Creates a playlist object which is an array of song objects
class playlistModel: NSObject {
    var name: String
    var list: [songModel] = []
    
    
    init(name:String, list: [songModel]) {
        self.name = name
        self.list = list
    }
    
    //adds new song to a playlist based on user input and sorts after adding
    func add(newSong:songModel){
        list.append(newSong)
        list.sort({ $0.title < $1.title })
    }
    
    //removes a song based on the index
    func remove(toRemove:Int){
        list.removeAtIndex(toRemove)
        list.sort({ $0.title < $1.title })
    }
    
    //uses the title entered by user to find and remove song
    func removeByTitle(toRemove:String,artist:String){
        var index:Int=0
        for song in list{
            if song.title == toRemove && song.artist == artist {
                list.removeAtIndex(index)
                list.sort({ $0.title < $1.title })
            }
            index++
        }
    }
    //searches for a song object based on the title
    func checkIfSongExists(title:String,artist:String) -> Bool {
        for song in list {
            if song.title == title && song.artist == artist{
                return true
            }
        }
        return false
    }
    
    //makes an array of the existing songs
    func listAllSongs()->[String]{
        var allSong: [String] = []
        for i in list{
            allSong.append(i.title)
        }
        return allSong
    }
    
    //makes ana array of songs by one artist
    func listArtistSong(artist:String)->[String]{
        var artistList: [String] = []
        for i in list{
            if(artist == i.artist){
                artistList.append(i.title)
            }
        }
        return artistList
    }
    //finds a song
    func accessSong(index:Int) -> songModel? {
        return index >= list.count ? nil : list[index]
    }
    
    //finds a song using the title
    func accessSongByTitle(title:String) -> songModel?{
        for song in list {
            if song.title == title {
                return song
            }
        }
        return nil
    }
}