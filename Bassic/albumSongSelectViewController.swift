//
//  albumSongSelectViewController.swift
//  Bassic
//
//  Created by Andrew Sowers on 2/22/15.
//  Copyright (c) 2015 Andrew Sowers. All rights reserved.
//

import Foundation
import UIKit
class AlbumSongSelectViewController : UITableViewController, UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet var songTableView: UITableView!
    
    let playlist = SharedPlaylistController.sharedInstance.accessPlaylist("All songs")
    
    var songList:[String:(String,String)] = Dictionary()
    var searchingTableData:[String] = Array()
    
    
    var is_searching:Bool = false
    
    var currentRow:Int = 0
    
    var albumName:String = String()
    
    
    override func viewDidLoad(){
        self.navigationController?.navigationBar.tintColor = uicolorFromHex(0xe1a456)
        songTableView.delegate = self
        songTableView.dataSource = self
        
    }
    
    override func viewWillAppear(animated:Bool){
         self.songList = playlist.listArtistSongByAlbum(self.albumName)
        self.songTableView.reloadData()
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
    
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    
    // MARK searching delegate logic
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        
        if searchBar.text.isEmpty{
            is_searching = false
            songTableView.reloadData()
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
            songTableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        is_searching = false
        
        songTableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        // Create a new variable to store the instance of PlayerTableViewController
        let destinationVC = segue.destinationViewController as songViewController
        //destinationVC.playlistTitle = self.playlistTableData[self.currentRow]
        if is_searching == true{
            let song:(String,String) =  songList[searchingTableData[self.currentRow]]!
            for songInList in playlist.list {
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
            let song:(String,String) = songList[Array(songList.keys)[self.currentRow]]!
            for songInList in playlist.list {
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