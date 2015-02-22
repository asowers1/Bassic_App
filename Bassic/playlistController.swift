/********************************************************************
*  playlistController.swift
*  Bassic
*  Date Modified: 2/17/2015
*  Purpose: this class includes a whole song library and functions to manipulate playlist
*  Input: NA
*  Output:NA
*  Created by Andrew Sowers on 2/3/15.
*  Copyright (c) 2015 Andrew Sowers. All rights reserved.
*********************************************************************/

import Foundation

class playlistController {
    
    
    //made up of Playlist data structure [String : songModel]
    
    var playlistDict:[String: playlistModel] = ["All songs":playlistModel(name: "All songs",list: [])]
/********************************************************************
*Function addPlaylist
*Purpose: creates a new playlist object
*Parameters: String name
*Return value: Bool
*Properties modified: playListController
*Precondition: NA
*********************************************************************/
    func addPlaylist(name:String) -> Bool {
        if (playlistDict[name]==nil){
            playlistDict[name] = playlistModel(name: name, list: [])
            return true
        }
        return false
    }
/********************************************************************
*Function removePlaylist
*Purpose: remove a playlist object
*Parameters: String name
*Return value: Bool
*Properties modified: NA
*Precondition: NA
*********************************************************************/
    func removePlaylist(name:String) -> Bool {
        if (playlistDict[name] != nil && name != "All songs") {
            playlistDict[name] = nil
            return true
        }
        return false
    }
/********************************************************************
*Function accessPlaylist
*Purpose: allows user to edit playlist
*Parameters: String name
*Return value: playListModel
*Properties modified: NA
*Precondition: NA
*********************************************************************/
    func accessPlaylist(name:String)->playlistModel {
        return playlistDict[name]!
    }
/********************************************************************
*Function getPlaylistList
*Purpose: displays the sorted titles of songs in all playlists
*Parameters: NA
*Return value: [String] sortedKays
*Properties modified: NA
*Precondition: NA
*********************************************************************/
    func getPlaylistList() -> [String] {
        let sortedKeys = Array(playlistDict.keys).sorted(<)
        return sortedKeys
    }
    
/********************************************************************
*Function getPlaylistListMinusAllSongs
*Purpose: displays the sorted titles of songs in all playlists except 'All songs'
*Parameters: NA
*Return value: [String] sortedKays
*Properties modified: NA
*Precondition: NA
*********************************************************************/
    func getPlaylistListMinusAllSongs() -> [String] {
        let sortedKeys = Array(playlistDict.keys).sorted(<)
        var returnList:[String] = Array()
        for key in sortedKeys {
            if key != "All songs" {
                returnList.append(key)
            }
        }
        return returnList
    }
    
/********************************************************************
*Function getAllArtistsFromPlaylists
*Purpose: displays the sorted artists from all playlists
*Parameters: NA
*Return value: [String] sortedKays
*Properties modified: NA
*Precondition: NA
*********************************************************************/
    func getAllArtistsFromPlaylists() -> [String] {
        var artistList:[String] = Array()
        for artist in playlistDict {
            artistList += artist.1.getArtistList()
        }
        artistList.sort({$0 < $1})
        return artistList
    }
    
/********************************************************************
*Function addSongToPlaylist
*Purpose: adds a song object to a playlist
*Parameters: String songTitle, songArtist,songAlbum, songLength, songYear, songComposer
*Return value: true
*Properties modified: playList
*Precondition: NA
*********************************************************************/
    func addSongToPlaylist(playlistName:String, songTitle:String, songArtist:String, songAlbum:String, songLength:String, songYear:String, songComposer:String) -> Bool {
    
        var song:Song = Song(name: songTitle, artist: songArtist, album: songAlbum, year: songYear.toInt()!, composer: songComposer, length: songLength.toInt()!)
        playlistDict[playlistName]?.add(song)
        return true
    }
/********************************************************************
*Function referenceSongFromPLaylistToPlaylist
*Purpose: lests user reference songs from other playlists
*Parameters: String sourcePLaylistName, destPlaylistName, songName
*Return value: Bool
*Properties modified: NA
*Precondition: NA
*********************************************************************/
    func referenceSongFromPLaylistToPlaylist(sourcePLaylistName:String,destPlaylistName:String,songName:String) -> Bool{
        let sourcePlaylist = playlistDict[sourcePLaylistName]
        let destPlaylist   = playlistDict[destPlaylistName]
        if let song:Song = sourcePlaylist?.accessSongByTitle(songName) as Song! {
            destPlaylist?.add(song)
            return true
        }
        return false
    }
}