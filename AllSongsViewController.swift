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
    
    @IBOutlet weak var artistTableView: UITableView!
    
    var playlists:playlistController = SharedPlaylistController.sharedInstance
    
    var songList:[String] = Array()
    var searchingTableData:[String] = Array()
    
    var currentRow:Int = 0
    
    let textCellIdentifier = "cell"
    
    var is_searching:Bool = false
    
    override func viewDidLoad(){
        self.artistTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.songList = playlists.accessPlaylist("All songs").listAllSongs()
        self.artistTableView.dataSource = self
        self.artistTableView.delegate = self

    }
    
    override func viewWillAppear(animated: Bool) {
         self.navigationController?.navigationBar.topItem?.title = "Songs"
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
            cell.textLabel?.text = self.songList[indexPath.row]
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        artistTableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.currentRow = indexPath.row
        
    }
    
    // MARK searching delegate logic
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        
        if searchBar.text.isEmpty{
            is_searching = false
            
            artistTableView.reloadData()
        } else {
            println(" search text %@ ",searchBar.text as NSString)
            is_searching = true
            searchingTableData.removeAll(keepCapacity: false)
            for var index = 0; index < songList.count; index++
            {
                var currentString = songList[index]
                if currentString.lowercaseString.rangeOfString(searchText.lowercaseString)  != nil {
                    searchingTableData.append(currentString)
                    searchingTableData.sort({$0 < $1})
                }
            }
            artistTableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        is_searching = false
        
        artistTableView.reloadData()
    }


}