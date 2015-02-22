/********************************************************************
*  playlistModel.swift
*  Bassic
*  data modified: 2/17/2015
*  purpose: this class is a playlist object model
*  input:NA
*  output:NA
*  Created by Andrew Sowers on 2/3/15.
*  Copyright (c) 2015 Andrew Sowers. All rights reserved.
*********************************************************************/

import Foundation
import UIKit


//Creates a playlist object which is an array of song objects
class playlistModel {
    var name: String = String()
    var list: [Song] = []
    
    
    init(name:String, list: [Song]) {
        self.name = name
        self.list = list
    }
    
/********************************************************************
    // Function: getArtistList
    // Purpose: get a sorted list of artists from this playlist
    // Parameters: None.
    // Return Value: [String]
    // Properties modified: None.
    // Preconditions: NA
********************************************************************/
    func getArtistList() -> [String] {
        var artistList:[String] = Array()
        for song in list {
            artistList.append(song.artist)
        }
        artistList.sort({$0 < $1})
        return artistList
    }
    
/********************************************************************
    //Function add
    //Purpose: add song object to list object
    //Parameters: songModel newSong - song to be added
    //Return value: none
    //Properties modified: list object - now contains newSong
    //Precondition - N/A
********************************************************************/
    func add(newSong:Song){
        list.append(newSong)
        list.sort({ $0.name < $1.name })
    }
/********************************************************************
    //Function remove
    //Purpose: removes song from the list object
    //Parameters: Int toRemove: index of song to be removed
    //Return value: none
    //Properties modified: list object - song at index toRemove 
    is no longer in the song object
    //Precondition - N/A
********************************************************************/
    func remove(toRemove:Int){
        list.removeAtIndex(toRemove)
        list.sort({ $0.name < $1.name })
    }
/********************************************************************
    //Function removeByTitle
    //Purpose: removed a song object from list based on the 
    songsModel's title
    //Parameters: String toRemove: title of the songModel to be 
    removed
    //String artist: artist of the songModel to be removed
    //Return value: none
    //Properties modified: list object - songModel with title toRemove 
    and artist artist is no longer in list object
    //Precondition - N/A
*********************************************************************/
    func removeByTitle(toRemove:String,artist:String){
        var index:Int=0
        for song in list{
            if song.name == toRemove && song.artist == artist {
                list.removeAtIndex(index)
                list.sort({ $0.name < $1.name })
            }
            index++
        }
    }
/********************************************************************
    //Function checkIfSongExsists
    //Purpose: Make sure songModel user is looking for is in list
    //Parameters: String toRemove: title of the songModel to be
    removed
    //String artist: artist of the songModel to be removed
    //Return value: true or false depending on if songModel with 
    title and artist is in list
    //Properties modified: none
    //Precondition - N/A
*********************************************************************/
    func checkIfSongExists(title:String,artist:String) -> Bool {
        for song in list {
            if song.name == title && song.artist == artist{
                return true
            }
        }
        return false
    }
/********************************************************************
    //Function listAllSongs
    //Purpose: create and display a list of all the songs within the
    app
    //Parameters: None
    //Return value: list containing all the songs in the application
    //Properties modified: none
    //Precondition - N/A
*********************************************************************/
    func listAllSongs()->[String]{
        var allSong: [String] = []
        for i in list{
            allSong.append(i.name)
        }
        return allSong
    }
/********************************************************************
    //Function listArtistSongs
    //Purpose: create and display a list of all the songs by one 
    artisit
    //Parameters: String artist - artist to compare to all 
    songModel's artist attribute
    //Return value: list containing all the songs by an artist
    //Properties modified: none
    //Precondition - N/A
*********************************************************************/
    func listArtistSong(artist:String)->[String]{
        var artistList: [String] = []
        for i in list{
            if(artist == i.artist){
                artistList.append(i.name)
            }
        }
        return artistList
    }
/********************************************************************
    //THIS ONE
    //Function accessSong
    //Purpose: locate a songModel using the index
    //Parameters: Int index - index of songModel in list to remove
    //Return value: index
    //Properties modified: none
    //Precondition - N/A
*********************************************************************/
    func accessSong(index:Int) -> Song? {
        return index >= list.count ? nil : list[index]
    }
/********************************************************************
    //THIS ONE
    //Function accessSongByTitle
    //Purpose: locate songModel in list object using title property
    //Parameters: String title - title of songModel in list to remove
    //Return value: songModel searching for or nothing if songModel 
    doesn't exsist
    //Properties modified: none
    //Precondition - N/A
*********************************************************************/
    func accessSongByTitle(title:String) -> Song?{
        for song in list {
            if song.name == name {
                return song
            }
        }
        return nil
    }
}