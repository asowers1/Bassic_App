//
//  Song.swift
//  IOS Music App
//
//  Created by Charles Woodward and Jordan Smith on 2/8/15.
//  Copyright (c) 2015 Sugr. All rights reserved.
//  class Song{} encapsulates the data for a single song
//  class variables: string(Name of song); string(name of artist); string(name of album); int(year of release); string(name of composer); int(duration in seconds)

import Foundation

class Song {
    var name: String
    var artist: String
    var album: String
    var year: Int
    var composer: String
    var length: Int
    
    
    
    //Constructor
    //Param in: string(Song Name); string(Artist Name); string(Album Name); int(Year of Release); int(Song Duration in sec)
    //Initializes an instance of the class with the passed values;
    
    init(name: String, artist: String, album: String, year: Int, composer: String, length: Int){
        self.name = name
        self.artist = artist
        self.album = album
        self.year = year
        self.composer = composer
        self.length = length
    }
}