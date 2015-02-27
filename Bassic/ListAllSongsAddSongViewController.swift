//
//  ListAllSongsAddSongViewController.swift
//  Bassic
//
//  Created by Andrew Sowers on 2/23/15.
//  Copyright (c) 2015 Andrew Sowers. All rights reserved.
//

import Foundation
import UIKit


/*******************************************************************
//Class ListAllSongsAddSongViewController
//Purpose: Creates a view for the addSong and allSongs page
*********************************************************************/
class ListAllSongsAddSongViewController : UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet var songTableView: UITableView!
    
    let playlist = SharedPlaylistController.sharedInstance.accessPlaylist("All songs")
    
    var songList:[String:(String,String)] = Dictionary()
    var searchingTableData:[String] = Array()
    
    
    var is_searching:Bool = false
    
    var currentRow:Int = 0
    
    /********************************************************************
    *Function:viewWillAppear
    *Purpose:Displays time
    *Parameters:animated bool
    *Return:N/A
    *Properties modified:N/A
    *Precondition:N/A
    ********************************************************************/
    override func viewDidLoad(){
        
        self.songTableView.dataSource = self
        self.songTableView.delegate = self
        self.songTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    /********************************************************************
    *Function:viewWillAppear
    *Purpose:Displays time
    *Parameters:animated bool
    *Return:N/A
    *Properties modified:N/A
    *Precondition:N/A
    ********************************************************************/
    override func viewWillAppear(animated:Bool){
        self.songList = playlist.listSongArtistAlbum()
        self.songTableView.reloadData()
    }
    
    
    /********************************************************************
    *Function:tableView
    *Purpose:UITable view implementation
    *Parameters:tableView UITableView
    *Return:int count
    *Properties modified: NA
    *Precondition: Class must conform to UITableViewDelegate
    ********************************************************************/
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.is_searching == true {
            return self.searchingTableData.count
        }else{
            return self.songList.count;
        }
    }
    /********************************************************************
    *Function: tableView
    *Purpose: set cell for row in tableView
    *Parameters: tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath
    *Return: UITableViewCell
    *Properties modified: tableView cells
    *Precondition: Class must conform to UITableViewDelegate
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
    *Function: tableView
    *Purpose: set row color and set current row to index path row
    *Parameters: tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath
    *Return: Void.
    *Properties modified: currentRow to indexPath row
    *Precondition: Class must conform to UITableViewDelegate
    ********************************************************************/
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        selectedCell.contentView.backgroundColor = uicolorFromHex(0xe1a456)
        self.currentRow = indexPath.row
    }
    /********************************************************************
    *Function: tableView
    *Purpose: handle the deselection of a table row
    *Parameters: tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath
    *Return: Void.
    *Properties modified: cell contentView Background color
    *Precondition: Class must conform to UITableViewDelegate
    ********************************************************************/
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        // if tableView is set in attribute inspector with selection to multiple Selection it should work.
        // Just set it back in deselect
        var cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cellToDeSelect.contentView.backgroundColor = UIColor.whiteColor()
    }
    /********************************************************************
    *Function:uicolorFromHex
    *Purpose:change color from hex to UIColor
    *Parameters:animated rgbValue:UInt32
    *Return: UIColor
    *Properties modified: NA
    *Precondition: NA
    ********************************************************************/
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.06
        
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    /********************************************************************
    *Function: searchBar
    *Purpose: update when new text is being searched for
    *Parameters: searchBar: UISearchBar, textDidChange searchText
    *Return: Void.
    *Properties modified: is_Searching, searchingTableData, songList
    *Precondition:
    ********************************************************************/
    // MARK searching delegate logic
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        
        if searchBar.text.isEmpty{
            // reset
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
    *Purpose: reset data is search bar cancle button is clicked
    *Parameters: searchBar: UISearchBar
    *Return: Void.
    *Properties modified: is_searching
    *Precondition: Class must conform to UITableViewDelegate
    ********************************************************************/
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        is_searching = false
        
        songTableView.reloadData()
    }
}