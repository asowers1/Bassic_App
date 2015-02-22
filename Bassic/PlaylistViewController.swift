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
        playlists.addPlaylist("rock")
        playlists.addPlaylist("running")
        playlists.addPlaylist("classical")
    
        // initial songs
        playlists.addSongToPlaylist("All songs", songTitle: "Portway", songArtist: "Land Observations", songAlbum: "Roman Roads IV-XI", songLength: String(convertStringToTime("3:34")), songYear: "2012", songComposer: "Land Observations")
        playlists.addSongToPlaylist("All songs", songTitle: "Brandonburg Concerto No.1 in G, BWV 1048: 3. Allegro", songArtist: "Johann Sebastian Bach", songAlbum: "Bach Brandenburg Concertos; Orchestra Suites", songLength: String(convertStringToTime("4:44")), songYear: "1988"
            , songComposer: "Johann Sebastian Bach")
        
        
        // copy some songs from "All songs" into other playlists
        //playlists.referenceSongFromPLaylistToPlaylist("All songs", destPlaylistName: "classical", songName: "Brandonburg Concerto No.1 in G, BWV 1048: 3. Allegro")
        
        // access intial song listing
        //songList = playlists.accessPlaylist("All songs").listAllSongs()
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

        
        
        for index in 1900...2015 {
            yearList.append(String(index))
        }
        
        for totalSeconds in 0...1800 {
            var minutes:Int = totalSeconds / 60;
            var seconds:Int = totalSeconds % 60;
            if seconds < 10 {
                lengthList.append(String("\(minutes):0\(seconds)"))
            }else{
                lengthList.append(String("\(minutes):\(seconds)"))
            }
        }
        
                
        yearValue = yearList[0]
        lengthValue = lengthList[0]
        

        self.buildTestSet()
        playlistTableData = playlists.getPlaylistListMinusAllSongs()
        
        
        self.playlistTableView.dataSource = self
        self.playlistTableView.delegate   = self
        
        
        /*
        playlistStepperValue = Double(playlistPickerData.count)
        songListStepperValue = Double(songList.count)
        
        playlistStepper.value = playlistStepperValue
        songStepper.value = songListStepperValue
        */
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Playlists"
    }
    
   override func viewDidAppear(animated: Bool) {
    
    }
    
// MARK UITableView implementation


    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.is_searching == true {
            return self.searchingTableData.count
        }else{
            return self.playlistTableData.count;
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.playlistTableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        if is_searching == true{
            cell.textLabel?.text = self.searchingTableData[indexPath.row]
        }else{
            cell.textLabel?.text = self.playlistTableData[indexPath.row]
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.currentRow = indexPath.row
        
        performSegueWithIdentifier("songShow", sender: self)
    }
    
    
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
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        is_searching = false
        
        playlistTableView.reloadData()
    }
    
// MARK segue logic
    

    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        // Create a new variable to store the instance of PlayerTableViewController
        let destinationVC = segue.destinationViewController as songSelectViewController
        //destinationVC.playlistTitle = self.playlistTableData[self.currentRow]
        if is_searching == true{
            destinationVC.navigationItem.title = self.searchingTableData[self.currentRow]
        }else{
            destinationVC.navigationItem.title = self.playlistTableData[self.currentRow]
        }
        
        
    }
    



/********************************************************************
*Function numberOfComponantsInPickerView
*Purpose:define number of componants in picker view
*Parameters: String artist - artist to compare to all songModel's artist attribute
*Return value: Int 1
*Properties modified: none
*Precondition - N/A
*********************************************************************/
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

/********************************************************************
    //Function getSelctedPlaylist
    //Purpose: return selected playlist
    //Parameters: none
    //Return value: desired playlist
    //Properties modified: NA
    //Precondition: NA

    func getSelectedPlaylist() -> playlistModel {
        return playlists.accessPlaylist(playlistPickerData[playlistPickerView.selectedRowInComponent(0)])
    }
*********************************************************************/
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
        println("test")
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
    //Function artistConfigurationTextField
    //Purpose: text field for add artist UIAlertView
    //Parameters:UITextField textField
    //Return value: NA
    //Properties modified: NA
    //Precondition: NA
*********************************************************************/
    func artistConfigurationTextField(textField: UITextField!){
        if let tFild = textField {
            self.artistTextField = textField!
            self.artistTextField.placeholder = "Artist name"
        }
    }
/********************************************************************
    //Function handleCancel
    //Purpose: text field for add playlist UIAlertVie
    //Parameters:UIAlertAction alertView
    //Return value: NA
    //Properties modified: NA
    //Precondition: NA

    func handleCancel(alertView: UIAlertAction!) {
        
        self.playlistPickerData = self.playlists.getPlaylistList()
        self.playlistPickerView.reloadAllComponents()

    }
*********************************************************************/
/********************************************************************
    //Function artistiListToStringList
    //Purpose: turns [Srting] to String
    //Parameters: NA
    //Return value: String toReturn
    //Properties modified:
    //Precondition
*********************************************************************/
    func artistiListToStringList() -> String {
        var toReturn:String = ""
        for artist in artistList {
            toReturn = artist + "\n"
        }
        return toReturn
    }
/********************************************************************
    //Function searchByArtist
    //Purpose: Search for titles by artist in a particular playlist
    //Parameters: AnyObject sender
    //Return value: NA
    //Properties modified: NA
    //Precondition: NA
*********************************************************************/
    @IBAction func searchByArtist(sender: AnyObject) {
        
        println("searching for selected artist")
        var alert = UIAlertController(title: "List Artists in playlist", message: "Enter artist name:", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler(artistConfigurationTextField)
        //alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:handleCancel))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
            println("User clicked Ok button")
            //var playlist:playlistModel = self.getSelectedPlaylist()
            
            //self.artistList = playlist.listArtistSong(self.artistTextField.text)
            if self.artistList.count == 0 {
                let artists:String = self.artistiListToStringList()
                let alert2 = UIAlertView(title: "Songs by \(self.artistTextField.text)", message: "none", delegate: self, cancelButtonTitle: "Okay")
                alert2.show()
            }else{
                let artists:String = self.artistiListToStringList()
                let alert2 = UIAlertView(title: "Songs by \(self.artistTextField.text)", message: artists, delegate: self, cancelButtonTitle: "Okay")
                alert2.show()
            }
        }))
        self.presentViewController(alert, animated: true, completion: {
            println("completion block")
            
        })


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
 /********************************************************************
    //Function cancelAddSong
    //Purpose: Cancel add song IBAction
    //Parameters: AnyObject sender
    //Return value: NA
    //Properties modified: NA
    //Precondition: NA
********************************************************************/
    @IBAction func cancelAddSong(sender: AnyObject) {
        println("Cancel add song")
    }
/********************************************************************
    //Function dismissKeyboard
    //Purpose: Dismiss Keyboard IBAction
    //Parameters: AnyObject sender
    //Return value: NA
    //Properties modified: NA
    //Precondition: NA
*********************************************************************/
    @IBAction func dismissKeyboard(sender: AnyObject) {
        self.dismissKeyboards()
    }
/********************************************************************
    //Function dismissKeyboards
    //Purpose: Dismiss Keyboard method
    //Parameters: NA
    //Return value: NA
    //Properties modified: NA
    //Precondition: NA
*********************************************************************/
    func dismissKeyboards(){
        
    }

}
