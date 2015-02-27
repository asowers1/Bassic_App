/********************************************************************
*  bassicViewController.swift
*  Bassic
*  date modified: 2/17/2015
*  purpose: this class is used to control user interface view
*  input:NA
*  output:NA
*  Created by Andrew Sowers on 2/7/15.
*  Copyright (c) 2015 Andrew Sowers. All rights reserved.
*********************************************************************/

import UIKit
import Foundation

class PlaylistViewController: UITableViewController, UIAlertViewDelegate, UISearchBarDelegate {

    //MARK: - IBOutlets for user interface

    @IBOutlet weak var searchBar: UISearchBar!
    
    // main screen outlets
    

    @IBOutlet var playlistTableView: UITableView!
    
    let textCellIdentifier = "cell"


    // local data
    
    var is_searching:Bool = false   // It's flag for searching
    
    
    var playlists: playlistController = SharedPlaylistController.sharedInstance
    var playlistTableData:[String] = []
    var searchingTableData:[String] = []
    
    var songList:[String]           = []
    var yearList:[String]           = []
    var lengthList:[String]         = []
    var artistList:[String]         = []
    
    var currentRow = 0
    
    var lengthValue:String = String()
    var yearValue:String = String()
    
    // playlist input field
    var playlistTextField:UITextField = UITextField()
    
    // artist input field
    var artistTextField:UITextField = UITextField()
    
    
/********************************************************************
*Function buildTestSet
*Purpose: builds a few playlist objects with song objects in them
*Parameters: none
*Return value: none
*Properties modified: none
*Precondition - N/A
********************************************************************/
    func buildTestSet() {
        
        // initial playlists
        playlists.addPlaylist("rock",type: "playlist")
        playlists.addPlaylist("running",type: "playlist")
        playlists.addPlaylist("classical",type: "playlist")
    
        // initial songs
        playlists.addSongToPlaylist("All songs", songTitle: "Portway", songArtist: "Land Observations", songAlbum: "Roman Roads IV-XI", songLength: String(convertStringToTime("3:34")), songYear: "2012", songComposer: "Land Observations")
        playlists.addSongToPlaylist("All songs", songTitle: "Brandonburg Concerto No.1 in G, BWV 1048: 3. Allegro", songArtist: "Johann Sebastian Bach", songAlbum: "Bach Brandenburg Concertos; Orchestra Suites", songLength: String(convertStringToTime("4:44")), songYear: "1988"
            , songComposer: "Johann Sebastian Bach")
        
        
        // copy some songs from "All songs" into other playlists
        println(playlists.referenceSongFromPLaylistToPlaylist("All songs", destPlaylistName: "classical", songName: "Brandonburg Concerto No.1 in G, BWV 1048: 3. Allegro"))
        
        // access intial song listing
        //songList = playlists.accessPlaylist("All songs").listAllSongs()
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")


        self.buildTestSet()
        playlistTableData = playlists.getPlaylistListMinusAllSongs()
        
        
        self.playlistTableView.dataSource = self
        self.playlistTableView.delegate   = self
        
        
        for playlist in playlists.playlistDict{
            println("Length: \(playlist.1.calcPlaylistLength())")
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Playlists"
    }
    
    override func viewDidAppear(animated: Bool) {
    
    }
    /********************************************************************
    *Function:tableView
    *Purpose:UITable view implementation
    *Parameters:tableView UITableView
    *Return:int count
    *Properties modified:N/A
    *Precondition:N/A
    ********************************************************************/
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.is_searching == true {
            return self.searchingTableData.count
        }else{
            return self.playlistTableData.count;
        }
    }
    /********************************************************************
    *Function:
    *Purpose:
    *Parameters:
    *Return:
    *Properties modified:
    *Precondition:
    ********************************************************************/
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        if is_searching == true{
            cell.textLabel?.text = self.searchingTableData[indexPath.row]
        }else{
            //cell.textLabel?.text = self.songList[indexPath.row]
            cell.textLabel?.text = self.playlistTableData[indexPath.row]
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
        
        performSegueWithIdentifier("songShow", sender: self)
    }
    /********************************************************************
    *Function:
    *Purpose:
    *Parameters:
    *Return:
    *Properties modified:
    *Precondition:
    ********************************************************************/
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            self.playlists.removePlaylist(playlistTableData[indexPath.row])
            self.playlistTableData.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    /********************************************************************
    *Function:
    *Purpose:
    *Parameters:
    *Return:
    *Properties modified:
    *Precondition:
    ********************************************************************/
// MARK searching delegate logic
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        
        if searchBar.text.isEmpty{
            is_searching = false
            
            playlistTableView.reloadData()
        } else {
            println(" search text %@ ",searchBar.text as NSString)
            is_searching = true
            searchingTableData.removeAll(keepCapacity: false)
            for var index = 0; index < playlistTableData.count; index++
            {
                var currentString = playlistTableData[index]
                if currentString.lowercaseString.rangeOfString(searchText.lowercaseString)  != nil {
                    searchingTableData.append(currentString)
                    searchingTableData.sort({$0 < $1})
                }
            }
            playlistTableView.reloadData()
        }
    }
    /********************************************************************
    *Function:
    *Purpose:
    *Parameters:
    *Return:
    *Properties modified:
    *Precondition:
    ********************************************************************/
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        is_searching = false
        
        playlistTableView.reloadData()
    }
    
    
    
// MARK segue logic
    
    /********************************************************************
    *Function:
    *Purpose:
    *Parameters:
    *Return:
    *Properties modified:
    *Precondition:
    ********************************************************************/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        // Create a new variable to store the instance of PlayerTableViewController
        let destinationVC = segue.destinationViewController as songSelectViewController
        //destinationVC.playlistTitle = self.playlistTableData[self.currentRow]
        if is_searching == true{
            var data:Int = self.playlists.accessPlaylist(searchingTableData[self.currentRow]).calcPlaylistLength()
            let time = self.secondsToHoursMinutesSeconds(data)
            playlists.activePlaylist = searchingTableData[self.currentRow]
            if time.2 < 9 {
                destinationVC.navigationItem.title = String("\(self.searchingTableData[self.currentRow]) - \(time.1):0\(time.2)")
            }else{
                destinationVC.navigationItem.title = String("\(self.searchingTableData[self.currentRow]) - \(time.1):\(time.2)")
            }
            
        }else{
            var data:Int = self.playlists.accessPlaylist(playlistTableData[self.currentRow]).calcPlaylistLength()
            let time = self.secondsToHoursMinutesSeconds(data)
            playlists.activePlaylist = playlistTableData[self.currentRow]
            
            if time.2 < 9 {
                destinationVC.navigationItem.title = String("\(self.playlistTableData[self.currentRow]) - \(time.1):0\(time.2)")
            }else{
                destinationVC.navigationItem.title = String("\(self.playlistTableData[self.currentRow]) - \(time.1):\(time.2)")
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
    /********************************************************************
    *Function:addPlayList
    *Purpose:add playlist to the view
    *Parameters:AnyObeject
    *Return:N/A
    *Properties modified:N/A
    *Precondition:N/A
    ********************************************************************/
// MARK Title Bar Icons
    
    @IBAction func addPlaylist(sender: AnyObject) {
        var alert = UIAlertController(title: "Add Playlist", message: "Enter playlist name:", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler(playlistConfigurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
            println("User click Ok button")
            println(self.playlistTextField.text)
            if(self.playlists.addPlaylist(self.playlistTextField.text,type:"playlist")){
                self.playlistTableData = self.playlists.getPlaylistListMinusAllSongs()
                self.playlistTableView.reloadData()
            }
            
        }))
        self.presentViewController(alert, animated: true, completion: {
            println("completion block")
        })
    }
    
    func handleCancel() {
        
    }



/********************************************************************
//Function getMainPlaylist
//Purpose: return main playlist
//Parameters: none
//Return value: All Songs playlist
//Properties modified: NA
//Precondition: NA
********************************************************************/
    func getMainPlaylist() -> playlistModel {
        return playlists.accessPlaylist("All songs")
    }
/********************************************************************
    //Function alertView
    //Purpose: MARK UIAlertView Delegate
    //Parameters:UIAertView  - alertView, Int clickedButtonAtIndex buttonIndex
    //Return value:
    //Properties modified: NA
    //Precondition: NA
*********************************************************************/
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        println("Cancled UIAlert")
    }
    
/********************************************************************
    //Function playlistConfigurationTextField
    //Purpose: text field for add playlist UIAlertView
    //Parameters: UITextField - textField
    //Return value: NA
    //Properties modified: NA
    //Precondition: NA
*********************************************************************/
    func playlistConfigurationTextField(textField: UITextField!) {
        
        if let tField = textField {
            
            self.playlistTextField = textField!
            self.playlistTextField.placeholder = "Playlist Title"
        }
    }

/********************************************************************
    //Function convertStringToTime
    //Purpose: convert from UIPicker String selection to Int
    //Parameters: String time - 3:16
    //Return value: Int timeInt - in seconds
    //Properties modified: NA
    //Precondition: NA
********************************************************************/
    func convertStringToTime(time:String )->Int{
        let separated = split(time, {(c:Character)->Bool in return c==":"}, allowEmptySlices: false)
        let timeInt = ((separated[0].toInt()!*60)+separated[1].toInt()!)
        return timeInt
    }
}
