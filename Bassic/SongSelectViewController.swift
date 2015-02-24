//
//  songSelectView.swift
//  Bassic
//
//  Created by Andrew Sowers on 2/21/15.
//  Copyright (c) 2015 Andrew Sowers. All rights reserved.
//

import Foundation
import UIKit

class songSelectViewController: UITableViewController, UISearchBarDelegate {
    var playlistTitle:String = String()
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet var songSelectTableView: UITableView!
    
    var songList:[String:(String,String)] = Dictionary()
    var searchingTableData:[String] = Array()
    
    let playlists = SharedPlaylistController.sharedInstance
    
    var is_searching:Bool = false
    
    var currentRow:Int = 0
    
    
    
    override func viewDidLoad() {
        //self.navigationController?.navigationItem.title = self.playlistTitle
        self.navigationController?.navigationBar.tintColor = uicolorFromHex(0xe1a456)
        songSelectTableView.dataSource = self
        songSelectTableView.delegate = self
        playlistTitle = playlists.activePlaylist
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.songList = playlists.accessPlaylist(self.playlistTitle).listArtistSong()
        self.songSelectTableView.reloadData()
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.06
        
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    // MARK UITableView implementation
    
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
            cell.textLabel?.text = Array(songList.keys)[indexPath.row]
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.currentRow = indexPath.row
        
        //performSegueWithIdentifier("songShow", sender: self)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            println("remove: \(Array(songList.keys)[indexPath.row])")
            let song:(String,String) = songList[Array(songList.keys)[indexPath.row]]!
            self.playlists.removeSongFromPlaylist(self.playlistTitle, songName: song.1, artistName: song.0)
            self.songList.removeValueForKey(Array(songList.keys)[indexPath.row])
            
            var data:Int = self.playlists.accessPlaylist(self.playlistTitle).calcPlaylistLength()
            let time = self.secondsToHoursMinutesSeconds(data)
            self.navigationController?.navigationBar.topItem?.title = String("\(self.playlistTitle) - \(time.1):\(time.2)")
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    
    // MARK searching delegate logic
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        
        if searchBar.text.isEmpty{
            is_searching = false
            songSelectTableView.reloadData()
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
            songSelectTableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        is_searching = false
        
        songSelectTableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        // Create a new variable to store the instance of PlayerTableViewController
        let destinationVC = segue.destinationViewController as songViewController
        //destinationVC.playlistTitle = self.playlistTableData[self.currentRow]
        
        if is_searching == true{
            let currentPlaylist = playlists.accessPlaylist(self.playlistTitle)
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
                    
                    
                }
            }
        }else{
            let currentPlaylist = playlists.accessPlaylist(self.playlistTitle)
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
                    
                }
            }
        }
    }
}