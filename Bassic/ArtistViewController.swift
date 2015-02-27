//
//  artistViewController.swift
//  Bassic
//
//  Created by Andrew Sowers on 2/21/15.
//  Copyright (c) 2015 Andrew Sowers. All rights reserved.
//

import Foundation
import UIKit

class ArtistViewController : UITableViewController, UIAlertViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    let playlists = SharedPlaylistController.sharedInstance
   
    
    @IBOutlet var artistTableView: UITableView!
    
    var artistList:[String] = Array()
    var searchingTableData:[String] = Array()
    
    var currentRow:Int = 0
    
    let textCellIdentifier = "cell"
    
    var is_searching:Bool = false
    
    /********************************************************************
    *Function: viewDidLoad
    *Purpose: handle view did load
    *Parameters: Void.
    *Return: Void.
    *Properties modified: artistTableView
    *Precondition: Class must comply with UITableViewDatasource and UITableViewDelegate
    ********************************************************************/
    override func viewDidLoad(){
        self.artistTableView.dataSource = self
        self.artistTableView.delegate = self
        self.artistTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    /********************************************************************
    *Function: viewWillAppear
    *Purpose: handle view will appear
    *Parameters: animated: Bool
    *Return: Void.
    *Properties modified: artistList
    *Precondition: Must have data in playlists
    ********************************************************************/
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Artists"
        artistList = self.playlists.getAllArtistsFromPlaylists()
        self.artistTableView.reloadData()
        
    }

    /********************************************************************
    *Function: tableView
    *Purpose: set number of rows for tableView
    *Parameters: tableView: UITableView, numberOfRowsInSection section: Int
    *Return: Int
    *Properties modified: NA
    *Precondition: Class must conform to UITableViewDelegate
    ********************************************************************/
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.is_searching == true {
            return self.searchingTableData.count
        }else{
            return self.artistList.count;
        }
    }
    /********************************************************************
    *Function: tableView
    *Purpose: set cell text for row index path
    *Parameters: tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath
    *Return: UITableViewCell
    *Properties modified: NA
    *Precondition: NA
    ********************************************************************/
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        if is_searching == true{
            cell.textLabel?.text = self.searchingTableData[indexPath.row]
        }else{
            //cell.textLabel?.text = self.songList[indexPath.row]
            cell.textLabel?.text = self.artistList[indexPath.row]
        }
        return cell
    }
    /********************************************************************
    *Function: tableView
    *Purpose: set currentRow as indexpath
    *Parameters: tableView: UITableView, didSelectRowIndexPath indexPath: NSIndexPath
    *Return: Void.
    *Properties modified: currentRow
    *Precondition: Class must conform to UITableViewDelegate
    ********************************************************************/
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.currentRow = indexPath.row
        performSegueWithIdentifier("artistSongShow", sender: self)
    }
    /********************************************************************
    *Function: searchBar
    *Purpose: update search based on text
    *Parameters: searchBar: UISearchBar, textDidChange searchText: String
    *Return: Void.
    *Properties modified: is_searching, searcingTableData
    *Precondition: Class must conform to UISearchBarDelegate
    ********************************************************************/
    // MARK searching delegate logic
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        
        if searchBar.text.isEmpty{
            is_searching = false
            artistTableView.reloadData()
        } else {
            println(" search text %@ ",searchBar.text as NSString)
            is_searching = true
            searchingTableData.removeAll(keepCapacity: false)
            for var index = 0; index < self.artistList.count; index++
            {
                var currentString = artistList[index]
                if currentString.lowercaseString.rangeOfString(searchText.lowercaseString)  != nil {
                    searchingTableData.append(currentString)
                    searchingTableData.sort({$0 < $1})
                }
            }
            artistTableView.reloadData()
        }
    }
    
    /********************************************************************
    *Function: searchBarCancelButtonClicked
    *Purpose: handle cancle for search bar
    *Parameters: searchBar: UISearchBar
    *Return: Void.
    *Properties modified: is_searching
    *Precondition: Class must conform to UISearchBarDeletate and UITableViewDelegate
    ********************************************************************/
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        is_searching = false
        artistTableView.reloadData()
    }
    
    /********************************************************************
    *Function: prepareForSegue
    *Purpose: prepare for segue to ArtistSongSelectViewController
    *Parameters: segue: UIStoryboardSegue, sender AnyObject!
    *Return: Void.
    *Properties modified: NA
    *Precondition: Class must have segue indentifiers setup
    ********************************************************************/
    // MARK segue logic
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        // Create a new variable to store the instance of PlayerTableViewController
        let destinationVC = segue.destinationViewController as ArtistSongSelectViewController
        
        // get searching data
        if is_searching == true{
            var data:Int = self.playlists.accessPlaylist("All songs").calcArtistLength(searchingTableData[self.currentRow])
            let time = self.secondsToHoursMinutesSeconds(data)
            destinationVC.artistName = searchingTableData[self.currentRow]
            if time.2 < 9 {
                destinationVC.navigationItem.title = String("\(self.searchingTableData[self.currentRow]) - \(time.1):0\(time.2)")
            }else{
                destinationVC.navigationItem.title = String("\(self.searchingTableData[self.currentRow]) - \(time.1):\(time.2)")
            }
            
        }else{
            // get non searching data
            var data:Int = self.playlists.accessPlaylist("All songs").calcArtistLength(artistList[self.currentRow])
            let time = self.secondsToHoursMinutesSeconds(data)
            destinationVC.artistName = artistList[self.currentRow]
            if time.2 < 9 {
                destinationVC.navigationItem.title = String("\(self.artistList[self.currentRow]) - \(time.1):0\(time.2)")
            }else{
                destinationVC.navigationItem.title = String("\(self.artistList[self.currentRow]) - \(time.1):\(time.2)")
            }
        }
        
        
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
    
    
}