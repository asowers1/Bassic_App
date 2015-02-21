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
    
    var songList:[String]
    
    override init(){
        self.songList = playlists.getPlaylistList()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    
    
    
}