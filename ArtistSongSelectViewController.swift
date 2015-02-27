//
//  ArtistSongSelectViewController.swift
//  Bassic
//
//  Created by Andrew Sowers on 2/23/15.
//  Copyright (c) 2015 Andrew Sowers. All rights reserved.
//

import Foundation
import UIKit

/********************************************************************
//Class ArtistSongSelectViewController
//Purpose: dictionary that stores artists and their songs as value:key
*********************************************************************/
class ArtistSongSelectViewController : UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var songTableView: UITableView!
    
    let playlist = SharedPlaylistController.sharedInstance.accessPlaylist("All songs")
    
    var songList:[String:(String,String)] = Dictionary()
    var searchingTableData:[String] = Array()
    
    
    var is_searching:Bool = false
    var currentRow:Int = 0
    var artistName:String = String()
    
    /********************************************************************
    //Function viewDidLoad
    //Purpose: set navigationController color, set songTableView delegate and datasource
    //Parameters: animated Bool
    //Return value: NA
    //Properties modified: NA
    //Precondition: NA
    *********************************************************************/
    override func viewDidLoad(){
        self.navigationController?.navigationBar.tintColor = uicolorFromHex(0xe1a456)
        songTableView.delegate = self
        songTableView.dataSource = self
        
    }
    
    /********************************************************************
    //Function viewWillAppear
    //Purpose: reloads songList data, sets data in table, updates time in title
    //Parameters: animated Bool
    //Return value: NA
    //Properties modified: NA
    //Precondition: NA
    *********************************************************************/
    override func viewWillAppear(animated:Bool){
        self.songList = playlist.listArtistSongByArtist(self.artistName)
        self.songTableView.reloadData()
        var artistLength:Int = playlist.calcArtistLength(self.artistName)
        let time = self.secondsToHoursMinutesSeconds(artistLength)
        if time.2 < 9 {
            self.navigationItem.title =  String("\(self.artistName) - \(time.1):0\(time.2)")
        }else{
            self.navigationItem.title =  String("\(self.artistName) - \(time.1):\(time.2)")
        }
        
    }
    
    /********************************************************************
    *Function:uicolorFromHex
    *Purpose:change color from hex to UIColor
    *Parameters: rgbValue:UInt32
    *Return: UIColor
    *Properties modified:N/A
    *Precondition:N/A
    ********************************************************************/
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.06
        
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    /********************************************************************
    *Function:tableView
    *Purpose:UITable view implementation
    *Parameters:tableView UITableView
    *Return:int count: Int
    *Properties modified: None
    *Precondition: count properties are set
    ********************************************************************/
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.is_searching == true {
            return self.searchingTableData.count
        }else{
            return self.songList.count;
        }
    }
    
    /********************************************************************
    *Function:tableView
    *Purpose:fills the table view
    *Parameters: tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath
    *Return: UITableViewCell
    *Properties modified:
    *Precondition:
    ********************************************************************/
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        if is_searching == true{
            cell.textLabel?.text = self.searchingTableData[indexPath.row]
        }else{
            cell.textLabel?.text = Array(songList.keys)[indexPath.row]
        }
        return cell
    }
    /********************************************************************
    *Function:
    *Purpose:
    *Parameters:
    *Return:
    *Properties modified:
    *Precondition:
    ********************************************************************/
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.currentRow = indexPath.row
    }
    /********************************************************************
    *Function:secondsToHoursMinutesSeconds
    *Purpose:change seconds to format hours:minutes:seconds
    *Parameters:int seconds
    *Return:int hours, int minutes,int seconds
    *Properties modified:N/A
    *Precondition:N/A
    ********************************************************************/
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    
    /********************************************************************
    //Function searchBar
    //Purpose: allows users to search for something
    //Parameters: UISearchBar:searchBar String: textDidChangr, searchText
    //Return value: NA
    //Properties modified: NA
    //Precondition: NA
    *********************************************************************/
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
    /********************************************************************
    *Function: searchBarCancelButtonClicked
    *Purpose: when search bar cancle button is clicked, set is_searching to false, reload table view data
    *Parameters: searchBar: UISearchBar
    *Return: Void.
    *Properties modified: is_searching
    *Precondition: songTableView is instanciated
    ********************************************************************/
    //removes the search view
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        is_searching = false
        
        songTableView.reloadData()
    }
    /********************************************************************
    *Function: prepareForSegue
    *Purpose: prepare for the segue
    *Parameters: segue: UIStoryboardSegue, sender AnyObject!
    *Return: Void.
    *Properties modified: None.
    *Precondition: None.
    ********************************************************************/
    //Create a new variable to store the instance of PlayerTableViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        let destinationVC = segue.destinationViewController as songViewController
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
                    if time.2 < 9 {
                        destinationVC.length   = String(" \(time.1):0\(time.2)")
                    }else{
                        destinationVC.length   = String(" \(time.1):\(time.2)")
                    }
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
                    if time.2 < 9 {
                        destinationVC.length   = String(" \(time.1):0\(time.2)")
                    }else{
                        destinationVC.length   = String(" \(time.1):\(time.2)")
                    }
                }
            }
        }
    }
}