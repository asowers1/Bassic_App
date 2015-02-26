//
//  AllSongsViewController.swift
//  Bassic
//
//  Created by Andrew Sowers on 2/21/15.
//  Copyright (c) 2015 Andrew Sowers. All rights reserved.
//

import Foundation
import UIKit

class AllSongsViewController : UITableViewController, UIAlertViewDelegate, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UITableView!
    
    @IBOutlet weak var allSongsTableView: UITableView!
    
    var playlists:playlistController = SharedPlaylistController.sharedInstance
    
    var songList:[String:(String,String)] = Dictionary()
    var searchingTableData:[String] = Array()
    
    var currentRow:Int = 0
    
    let textCellIdentifier = "cell"
    
    var is_searching:Bool = false
    
    override func viewDidLoad(){
        self.allSongsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.allSongsTableView.dataSource = self
        self.allSongsTableView.delegate = self

    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Songs"
        self.songList = playlists.accessPlaylist("All songs").listSongArtistAlbum()
        self.allSongsTableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.is_searching == true {
            return self.searchingTableData.count
        }else{
            return self.songList.count;
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        if is_searching == true{
            cell.textLabel?.text = self.searchingTableData[indexPath.row]
        }else{
            //cell.textLabel?.text = self.songList[indexPath.row]
            cell.textLabel?.text = Array(songList.keys)[indexPath.row]
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        allSongsTableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.currentRow = indexPath.row
        self.performSegueWithIdentifier("songShow", sender: nil)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            println("remove: \(Array(songList.keys)[indexPath.row])")
            //self.playlists.removePlaylist(albumList[indexPath.row])
            let song:(String,String) = songList[Array(songList.keys)[indexPath.row]]!
            self.playlists.removeSongByArtist(song.1, songArtist: song.0)
            //self.albumList.removeAtIndex(indexPath.row)
            self.songList.removeValueForKey(Array(songList.keys)[indexPath.row])
            
            
            //self.playlists.removePlaylist(albumList[indexPath.row])
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    
    // MARK searching delegate logic
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        
        if searchBar.text.isEmpty{
            is_searching = false
            allSongsTableView.reloadData()
        } else {
            println(" search text %@ ",searchBar.text as NSString)
            is_searching = true
            searchingTableData.removeAll(keepCapacity: false)
            for var index = 0; index < songList.count; index++
            {
                var currentString = Array(songList.keys)[index]
                if currentString.lowercaseString.rangeOfString(searchText.lowercaseString)  != nil {
                    searchingTableData.append(currentString)
                    searchingTableData.sort({$0 < $1})
                }
            }
            allSongsTableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        is_searching = false
        allSongsTableView.reloadData()
    }
    
    // MARK segue logic
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if segue.identifier == "songShow" {
            // Create a new variable to store the instance of PlayerTableViewController
            let destinationVC = segue.destinationViewController as songViewController
            //destinationVC.playlistTitle = self.playlistTableData[self.currentRow]
            
            if is_searching == true{
                let currentPlaylist = playlists.accessPlaylist("All songs")
                let song:(String,String) =  songList[searchingTableData[self.currentRow]]!
                for songInList in currentPlaylist.list {
                    if songInList.artist == song.0 && songInList.name == song.1 {
                        let time:(Int,Int,Int) = self.secondsToHoursMinutesSeconds(songInList.length)
                        destinationVC.name     = songInList.name
                        destinationVC.artist   = songInList.artist
                        destinationVC.album    = songInList.album
                        destinationVC.year     = String(songInList.year)
                        destinationVC.composer = songInList.composer
                        destinationVC.length   = String(" \(time.1):\(time.2)")
                        destinationVC.lengthInSeconds = songInList.length
                        
                        
                    }
                }
            }else{
                let currentPlaylist = playlists.accessPlaylist("All songs")
                let song:(String,String) = songList[Array(songList.keys)[self.currentRow]]!
                for songInList in currentPlaylist.list {
                    if songInList.artist == song.0 && songInList.name == song.1 {
                        
                        let time:(Int,Int,Int) = self.secondsToHoursMinutesSeconds(songInList.length)
                        destinationVC.name     = songInList.name
                        destinationVC.artist   = songInList.artist
                        destinationVC.album    = songInList.album
                        destinationVC.year     = String(songInList.year)
                        destinationVC.composer = songInList.composer
                        destinationVC.length   = String(" \(time.1):\(time.2)")
                        destinationVC.lengthInSeconds = songInList.length
                        
                    }
                }
            }

        }
        
        
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    



}