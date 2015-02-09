//
//  bassicViewController.swift
//  Bassic
//
//  Created by Andrew Sowers on 2/7/15.
//  Copyright (c) 2015 Andrew Sowers. All rights reserved.
//

import UIKit
import Foundation

class bassicViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate {

    //MARK: - IBOutlets for user interface

    
    // main screen outlets
    
    // IBOutlet labels
    @IBOutlet weak var titleLabel:    UILabel!
    @IBOutlet weak var artistLabel:   UILabel!
    @IBOutlet weak var albumLabel:    UILabel!
    @IBOutlet weak var lengthLabel:   UILabel!
    @IBOutlet weak var yearLabel:     UILabel!
    @IBOutlet weak var composerLabel: UILabel!

    @IBOutlet weak var searchLabel: UIBarButtonItem!
    
    // IBOutlet pickers
    @IBOutlet weak var playlistPickerView: UIPickerView!
    @IBOutlet weak var songPickerView:     UIPickerView!
    
    // IBOutlet steppers
    @IBOutlet weak var playlistStepper: UIStepper!
    @IBOutlet weak var songStepper:     UIStepper!
    
    @IBOutlet weak var composerLabelStatic: UILabel!
    @IBOutlet weak var yearLabelStatic: UILabel!
    @IBOutlet weak var lengthLabelStatic: UILabel!
    @IBOutlet weak var albumLabelStatic: UILabel!
    @IBOutlet weak var artistLabelStatic: UILabel!
    @IBOutlet weak var titleLabelStatic: UILabel!
    @IBOutlet weak var songsLabelStatic: UILabel!
    @IBOutlet weak var playlistLabelStatic: UILabel!
    
    func toggleMainInterfaceOutlets(status:Bool){
        titleLabel.hidden = status
        artistLabel.hidden = status
        albumLabel.hidden = status
        lengthLabel.hidden = status
        yearLabel.hidden = status
        composerLabel.hidden = status
        playlistPickerView.hidden = status
        songPickerView.hidden = status
        composerLabelStatic.hidden = status
        yearLabelStatic.hidden = status
        lengthLabelStatic.hidden = status
        albumLabelStatic.hidden = status
        artistLabelStatic.hidden = status
        titleLabelStatic.hidden = status
        songsLabelStatic.hidden = status
        playlistLabelStatic.hidden = status
        playlistStepper.hidden = status
        songStepper.hidden = status
    }
    
    
    // add song outlets
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var composerInput: UITextField!
    @IBOutlet weak var albumInput: UITextField!
    @IBOutlet weak var artistInput: UITextField!
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var yearPickerView: UIPickerView!
    @IBOutlet weak var lengthPickerView: UIPickerView!
    @IBOutlet weak var addNewSongStatic: UILabel!

    func toggleAddSongOutlets(status:Bool) {
        addButton.hidden = status
        cancelButton.hidden = status
        composerInput.hidden = status
        albumInput.hidden = status
        artistInput.hidden = status
        titleInput.hidden = status
        yearPickerView.hidden = status
        lengthPickerView.hidden = status
        addNewSongStatic.hidden = status
    }
    

    // local data
    var playlistStepperValue:Double=0
    var songListStepperValue:Double=0
    
    var playlists: playlistController = playlistController()
    var playlistPickerData:[String] = []
    var songList:[String]           = []
    var yearList:[String]           = []
    var lengthList:[String]         = []
    var artistList:[String]         = []
    
    var lengthValue:String = String()
    var yearValue:String = String()
    
    // playlist input field
    var playlistTextField:UITextField = UITextField()
    
    // artist input field
    var artistTextField:UITextField = UITextField()
    
    
    // build test set of playlist and music data
    func buildTestSet() {
        
        // initial playlists
        playlists.addPlaylist("rock")
        playlists.addPlaylist("running")
        playlists.addPlaylist("classical")
    
        // initial songs
        playlists.addSongToPlaylist("All songs", songTitle: "Portway", songArtist: "Land Observations", songAlbum: "Roman Roads IV-XI", songLength: "3:34", songYear: "2012", songComposer: "Land Observations")
        playlists.addSongToPlaylist("All songs", songTitle: "Brandonburg Concerto No.1 in G, BWV 1048: 3. Allegro", songArtist: "Johann Sebastian Bach", songAlbum: "Bach Brandenburg Concertos; Orchestra Suites", songLength: "4:44", songYear: "1988"
            , songComposer: "Johann Sebastian Bach")
        
        
        // copy some songs from "All songs" into other playlists
        playlists.referenceSongFromPLaylistToPlaylist("All songs", destPlaylistName: "classical", songName: "Brandonburg Concerto No.1 in G, BWV 1048: 3. Allegro")
        
        // access intial song listing
        songList = playlists.accessPlaylist("All songs").listAllSongs()
        
        // put initial song from "All songs" onto UI
        if let initialSong:songModel = playlists.accessPlaylist("All songs").accessSong(0) as songModel! {
            titleLabel.text = initialSong.title
            artistLabel.text = initialSong.artist
            albumLabel.text = initialSong.album
            lengthLabel.text = initialSong.length
            yearLabel.text = initialSong.year
            composerLabel.text = initialSong.composer
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.toggleAddSongOutlets(true)
        
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
        
        playlistPickerView.dataSource = self
        playlistPickerView.delegate   = self
        songPickerView.dataSource     = self
        songPickerView.delegate       = self
        yearPickerView.dataSource     = self
        yearPickerView.delegate       = self
        lengthPickerView.dataSource   = self
        lengthPickerView.delegate     = self
        
        yearValue = yearList[0]
        lengthValue = lengthList[0]
        
        println("\(yearList)")
        
        self.buildTestSet()
        playlistPickerData = playlists.getPlaylistList()
        
        
        
        playlistStepperValue = Double(playlistPickerData.count)
        songListStepperValue = Double(songList.count)
        
        playlistStepper.value = playlistStepperValue
        songStepper.value = songListStepperValue
        
    }
    
    //MARK: - Delegates and data sources
    
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag==0){
            return playlistPickerData.count
        }else if (pickerView.tag==1){
            return songList.count
        }else if(pickerView.tag==2){
            return lengthList.count
        }else if(pickerView.tag==3){
            return yearList.count
        }
        return 0
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if(pickerView.tag==0){
            return playlistPickerData[row]
        }else if(pickerView.tag==1){
            return songList[row]
        }else if(pickerView.tag==2){
            return lengthList[row]
        }else if(pickerView.tag==3){
            return yearList[row]
        }
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag==3){
            self.yearValue = yearList[row]
        }else if (pickerView.tag==2){
            self.lengthValue = lengthList[row]
        }else if (pickerView.tag==1){
            let selectedPlaylist:playlistModel = playlists.accessPlaylist(playlistPickerData[playlistPickerView.selectedRowInComponent(0)])
            if let currentSong:songModel = selectedPlaylist.accessSong(row) as songModel! {
                titleLabel.text = currentSong.title
                artistLabel.text = currentSong.artist
                albumLabel.text = currentSong.album
                lengthLabel.text = currentSong.length
                yearLabel.text = currentSong.year
                composerLabel.text = currentSong.composer
            }
        }else if (pickerView.tag==0){
            let selectedPlaylist:playlistModel = playlists.accessPlaylist(playlistPickerData[playlistPickerView.selectedRowInComponent(0)])
            songList = selectedPlaylist.listAllSongs()
            songPickerView.reloadAllComponents()
            songListStepperValue = Double(songList.count)
            songStepper.value = songListStepperValue
            
            if let currentSong:songModel = selectedPlaylist.accessSong(0) as songModel! {
                titleLabel.text = currentSong.title
                artistLabel.text = currentSong.artist
                albumLabel.text = currentSong.album
                lengthLabel.text = currentSong.length
                yearLabel.text = currentSong.year
                composerLabel.text = currentSong.composer
            }else{
                titleLabel.text =    ""
                artistLabel.text =   ""
                albumLabel.text =    ""
                lengthLabel.text =   ""
                yearLabel.text =     ""
                composerLabel.text = ""
            }
        }
    }
    
    @IBAction func playlistStepperCallback(sender: UIStepper) {
        if sender.value >= playlistStepperValue {
            // add playlist
            
            
            var alert = UIAlertController(title: "Add Playlist", message: "Enter playlist name:", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addTextFieldWithConfigurationHandler(playlistConfigurationTextField)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:handleCancel))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
                println("User click Ok button")
                println(self.playlistTextField.text)
                if(self.playlists.addPlaylist(self.playlistTextField.text)){
                    self.playlistPickerData = self.playlists.getPlaylistList()
                    self.playlistPickerView.reloadAllComponents()
                    self.playlistStepperValue++
                }
                
            }))
            self.presentViewController(alert, animated: true, completion: {
                println("completion block")
            })
            
            
            
        }else if sender.value <= playlistStepperValue {
            // delete playlist
            let index:Int = playlistPickerView.selectedRowInComponent(0)
            let playlist:playlistModel = playlists.playlistDict[playlistPickerData[index]]!
            println("Playlist name: \(playlist.name)")
            if playlist.name != "All songs"{
                if(playlists.removePlaylist(playlistPickerData[index])==true){
                    playlistPickerData = playlists.getPlaylistList()
                    playlistPickerView.reloadAllComponents()
                    let selectedPlaylist:playlistModel = playlists.accessPlaylist(playlistPickerData[playlistPickerView.selectedRowInComponent(0)])
                    songList = selectedPlaylist.listAllSongs()
                    songPickerView.reloadAllComponents()
                    if let currentSong:songModel = selectedPlaylist.accessSong(0) as songModel! {
                        
                    }
                }else{
                    println("no songs here, buddy")
                }
            }else{
                sender.value = playlistStepperValue
                var alert = UIAlertController(title: "Cannot remove main playlist", message: "\"All songs\" is the main playlist and it cannot be removed", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: { alertAction in
                    alert.dismissViewControllerAnimated(true, completion: nil)
                }))
                presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    // adds or deletes new song based on stepper value
    @IBAction func songStepperCallback(sender: UIStepper) {
        println("song stepper")
        if sender.value >= songListStepperValue {
            // add song
            //var alert = UIAlertController(title: "Add song", message: "Enter song details:", preferredStyle: UIAlertControllerStyle.Alert)
            
            self.toggleMainInterfaceOutlets(true)
            self.toggleAddSongOutlets(false)
        

            
        } else if sender.value <= songListStepperValue {
            // delete song
            let playlistIndex:Int = playlistPickerView.selectedRowInComponent(0)
            if playlistIndex == 0 {
                // remove song in current playlist and update UI
                let songIndex = songPickerView.selectedRowInComponent(0)
                let playlist:playlistModel = playlists.playlistDict[playlistPickerData[playlistIndex]]!
                let songTitle = playlist.accessSong(songIndex)?.title
                let songArtist = playlist.accessSong(songIndex)?.artist
                playlist.remove(songIndex)
                songListStepperValue--
                songList = playlist.listAllSongs()
                songPickerView.reloadAllComponents()
                
                // remove in other playlists
                for list in playlists.playlistDict {
                    list.1.removeByTitle(songTitle!,artist: songArtist!)
                }
                
            }else{
                let playlist:playlistModel = playlists.playlistDict[playlistPickerData[playlistIndex]]!
                playlist.remove(songPickerView.selectedRowInComponent(0))
                songList = playlist.listAllSongs()
                songPickerView.reloadAllComponents()
            }
            
        }
    }
    
    // gets current selected playlist from playlistPickerView
    func getSelectedPlaylist() -> playlistModel {
        return playlists.accessPlaylist(playlistPickerData[playlistPickerView.selectedRowInComponent(0)])
    }
    
    // gets the main playlist object
    func getMainPlaylist() -> playlistModel {
        return playlists.accessPlaylist("All songs")
    }
    
    
    //MARK UIAlertView Delegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        println("test")
    }
    
    
    //MARK alertView input
    
    // text field for add playlist UIAlertView
    func playlistConfigurationTextField(textField: UITextField!) {
        
        if let tField = textField {
            
            self.playlistTextField = textField!
            self.playlistTextField.placeholder = "Playlist Title"
        }
    }
    
     // text field for add artist UIAlertVie
    func artistConfigurationTextField(textField: UITextField!){
        if let tFild = textField {
            self.artistTextField = textField!
            self.artistTextField.placeholder = "Artist name"
        }
    }
    
     // text field for add playlist UIAlertVie
    func handleCancel(alertView: UIAlertAction!) {
        // may be surpufolous

    }
    
     // turns [Srting] to String
    func artistiListToStringList() -> String {
        var toReturn:String = ""
        for artist in artistList {
            toReturn = artist + "\n"
        }
        return toReturn
    }
    
     // Search for titles by artist in a particular playlist
    @IBAction func searchByArtist(sender: AnyObject) {
        
        println("searching for selected artist")
        var alert = UIAlertController(title: "List Artists in playlist", message: "Enter artist name:", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler(artistConfigurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:handleCancel))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
            println("User clicked Ok button")
            var playlist:playlistModel = self.getSelectedPlaylist()
            
            self.artistList = playlist.listArtistSong(self.artistTextField.text)
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
    
     // add song IBAction
    @IBAction func addSong(sender: AnyObject) {
        if titleInput.text != "" && artistInput.text != "" && albumInput.text != "" && composerInput.text != "" {
            
            var selectedPlaylist:playlistModel = self.getSelectedPlaylist()
            if selectedPlaylist.checkIfSongExists(titleInput.text,artist: artistInput.text){
                let alert = UIAlertView(title: "Hey Buddy", message: "You can't add a song with the same title and artist in a playlist", delegate: self, cancelButtonTitle: "Okay")
                alert.show()
                return
            }
            
            let newSong:songModel = songModel(title: titleInput.text, artist: artistInput.text, album: albumInput.text, length: self.lengthValue, year: self.yearValue, composer: composerInput.text)
            
            
            if selectedPlaylist.name != "All songs" {
                
                let mainPlaylist:playlistModel = self.getMainPlaylist()
                mainPlaylist.add(newSong)
                selectedPlaylist.add(newSong)
            }else {
                selectedPlaylist.add(newSong)
            }
            songList = selectedPlaylist.listAllSongs()
            songPickerView.reloadAllComponents()
            songListStepperValue++
            toggleAddSongOutlets(true)
            toggleMainInterfaceOutlets(false)
        }else{
            let alert = UIAlertView(title: "Hey Buddy", message: "Aren't you forgetting a few fields?", delegate: self, cancelButtonTitle: "It seems you're right")
            alert.show()
        }
    }
    
     // Cancel add song IBAction
    @IBAction func cancelAddSong(sender: AnyObject) {
        println("Cancel add song")
        toggleAddSongOutlets(true)
        toggleMainInterfaceOutlets(false)
    }
    
   
     // Dismiss Keyboard IBAction
    @IBAction func dismissKeyboard(sender: AnyObject) {
        self.dismissKeyboards()
    }
    
     // Dismiss Keyboard method
    func dismissKeyboards(){
        titleInput.endEditing(true)
        artistInput.endEditing(true)
        albumInput.endEditing(true)
        composerInput.endEditing(true)
    }

}
