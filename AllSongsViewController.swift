//
//  AllSongsViewController.swift
//  Bassic
//
//  Created by Andrew Sowers on 2/21/15.
//  Copyright (c) 2015 Andrew Sowers. All rights reserved.
//

import Foundation
import UIKit

class AllSongsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var playlists:playlistController = SharedPlaylistController.sharedInstance
    
    var songList:[String] = Array()
    
    var currentRow:Int = 0
    
    let textCellIdentifier = "TextCell"
    
    override func viewDidLoad(){
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.songList = playlists.accessPlaylist("All songs").listAllSongs()
        self.tableView.dataSource = self
        self.tableView.delegate = self

    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songList.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        cell.textLabel?.text = self.songList[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.currentRow = indexPath.row
        
        }
    
}