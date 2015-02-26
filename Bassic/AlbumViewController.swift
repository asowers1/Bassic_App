//
//  AlbumViewController.swift
//  Bassic
//
//  Created by Andrew Sowers on 2/22/15.
//  Copyright (c) 2015 Andrew Sowers. All rights reserved.
//

import Foundation
import UIkit

class AlbumViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    let playlists = SharedPlaylistController.sharedInstance
    
    
    @IBOutlet var albumTableView: UITableView!
    
    var albumList:[String] = Array()
    var searchingTableData:[String] = Array()
    
    var currentRow:Int = 0
    
    let textCellIdentifier = "cell"
    
    var is_searching:Bool = false
    
    // playlist input field
    var albumInputTextField:UITextField = UITextField()
    
    
    override func viewDidLoad(){
        self.albumTableView.dataSource = self
        self.albumTableView.delegate = self
        self.albumTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Albums"
        albumList = self.playlists.getAllAlbums()
        albumTableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.is_searching == true {
            return self.searchingTableData.count
        }else{
            return self.albumList.count;
        }

    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        if is_searching == true{
            cell.textLabel?.text = self.searchingTableData[indexPath.row]
        }else{
            cell.textLabel?.text = albumList[indexPath.row]
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.currentRow = indexPath.row
        performSegueWithIdentifier("albumSongShow", sender: self)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            println("remove: \(albumList[indexPath.row])")
            self.playlists.removePlaylist(albumList[indexPath.row])
            self.albumList.removeAtIndex(indexPath.row)
            
            
            
            //self.playlists.removePlaylist(albumList[indexPath.row])
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    
    
    @IBAction func addAlbum(sender: AnyObject) {
        var alert = UIAlertController(title: "Add Album", message: "Enter Album name:", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler(albumConfigurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
            println("User click Ok button")
            println(self.albumInputTextField.text)
            if(self.playlists.addPlaylist(self.albumInputTextField.text,type:"album")){
                self.albumList = self.playlists.getAllAlbums()
                self.albumTableView.reloadData()
            }
            
        }))
        self.presentViewController(alert, animated: true, completion: {
            println("completion block")
        })
    }

    /********************************************************************
    //Function albumConfigurationTextField
    //Purpose: text field for add album UIAlertView
    //Parameters: UITextField - textField
    //Return value: NA
    //Properties modified: NA
    //Precondition: NA
    *********************************************************************/
    func albumConfigurationTextField(textField: UITextField!) {
        
        if let tField = textField {
            
            self.albumInputTextField = textField!
            self.albumInputTextField.placeholder = "Album Title"
        }
    }
    
    
    // MARK searching delegate logic
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        
        if searchBar.text.isEmpty{
            is_searching = false
            albumTableView.reloadData()
        } else {
            println(" search text %@ ",searchBar.text as NSString)
            is_searching = true
            searchingTableData.removeAll(keepCapacity: false)
            for var index = 0; index < albumList.count; index++
            {
                var currentString = albumList[index]
                if currentString.lowercaseString.rangeOfString(searchText.lowercaseString)  != nil {
                    searchingTableData.append(currentString)
                    searchingTableData.sort({$0 < $1})
                }
            }
            albumTableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        is_searching = false
        albumTableView.reloadData()
    }
    
    // MARK segue logic
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        // Create a new variable to store the instance of PlayerTableViewController
        let destinationVC = segue.destinationViewController as AlbumSongSelectViewController
        
        
        if is_searching == true{
            var data:Int = self.playlists.accessPlaylist("All songs").calcAlbumLength(searchingTableData[self.currentRow])
            let time = self.secondsToHoursMinutesSeconds(data)
            destinationVC.albumName = searchingTableData[self.currentRow]
            if time.2 < 9 {
                destinationVC.navigationItem.title = String("\(self.searchingTableData[self.currentRow]) - \(time.1):0\(time.2)")
            }else{
                destinationVC.navigationItem.title = String("\(self.searchingTableData[self.currentRow]) - \(time.1):\(time.2)")
            }
            
        }else{
            var data:Int = self.playlists.accessPlaylist("All songs").calcAlbumLength(albumList[self.currentRow])
            let time = self.secondsToHoursMinutesSeconds(data)
            destinationVC.albumName = albumList[self.currentRow]
            if time.2 < 9 {
                destinationVC.navigationItem.title = String("\(self.albumList[self.currentRow]) - \(time.1):0\(time.2)")
            }else{
                destinationVC.navigationItem.title = String("\(self.albumList[self.currentRow]) - \(time.1):\(time.2)")
            }
        }
        
        
    }
    
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    
    
}