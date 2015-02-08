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
    @IBOutlet weak var playlistPickerView: UIPickerView!
    @IBOutlet weak var songPickerView: UIPickerView!
    
    @IBOutlet weak var playlistStepper: UIStepper!
    @IBOutlet weak var songStepper: UIStepper!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var composerLabel: UILabel!

    var playlistStepperValue:Double=0
    var songListStepperValue:Double=0
    
    var playlists: playlistController = playlistController()
    var playlistPickerData:[String] = []
    var songList:[String] = []
    
    // playlist input field
    var playlistTextField:UITextField = UITextField()
    
    // song input fields
    var titleTextField:UITextField    = UITextField()
    var artistTextField:UITextField   = UITextField()
    var albumTextField:UITextField    = UITextField()
    var lengthTextField:UITextField   = UITextField()
    var yearTextField:UITextField     = UITextField()
    var composerTextField:UITextField = UITextField()
    
    // build test set of playlist and music data
    func buildTestSet() {
        
        // initial playlists
        playlists.addPlaylist("rock")
        playlists.addPlaylist("running")
        playlists.addPlaylist("classical")
    
    
        // initial songs
        playlists.addSongToPlaylist("All songs", songTitle: "Portway", songArtist: "Land Observations", songAlbum: "Roman Roads IV-XI", songLength: 3.34, songYear: 2012, songComposer: "Land Observations")
        playlists.addSongToPlaylist("All songs", songTitle: "Brandonburg Concerto No.1 in G, BWV 1048: 3. Allegro", songArtist: "Johann Sebastian Bach", songAlbum: "Bach Brandenburg Concertos; Orchestra Suites", songLength: 4.44, songYear: 1988, songComposer: "Johann Sebastian Bach")
        
        
        // copy some songs from "All songs" into other playlists
        playlists.referenceSongFromPLaylistToPlaylist("All songs", destPlaylistName: "classical", songName: "Brandonburg Concerto No.1 in G, BWV 1048: 3. Allegro")
        
        // access intial song listing
        songList = playlists.accessPlaylist("All songs").listAllSongs()
        
        // put initial song from "All songs" onto UI
        if let initialSong:songModel = playlists.accessPlaylist("All songs").accessSong(0) as songModel! {
            titleLabel.text = initialSong.title
            artistLabel.text = initialSong.artist
            albumLabel.text = initialSong.album
            lengthLabel.text = String(format: "%.02f",initialSong.length)
            yearLabel.text = String(format: "%d", initialSong.year)
            composerLabel.text = initialSong.composer
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playlistPickerView.dataSource = self
        playlistPickerView.delegate = self
        songPickerView.dataSource = self
        songPickerView.delegate = self
        
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
        }
        return 0
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if(pickerView.tag==0){
            return playlistPickerData[row]
        }else if(pickerView.tag==1){
            return songList[row]
        }
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag==1){
            let selectedPlaylist:playlistModel = playlists.accessPlaylist(playlistPickerData[playlistPickerView.selectedRowInComponent(0)])
            if let currentSong:songModel = selectedPlaylist.accessSong(row) as songModel! {
                titleLabel.text = currentSong.title
                artistLabel.text = currentSong.artist
                albumLabel.text = currentSong.album
                lengthLabel.text = String(format: "%.02f", currentSong.length)
                yearLabel.text = String(format: "%d", currentSong.year)
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
                lengthLabel.text = String(format: "%.02f", currentSong.length)
                yearLabel.text = String(format: "%d", currentSong.year)
                composerLabel.text = currentSong.composer
            }else{
                titleLabel.text = ""
                artistLabel.text = ""
                albumLabel.text = ""
                lengthLabel.text = ""
                yearLabel.text = ""
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
    
    
    @IBAction func songStepperCallback(sender: UIStepper) {
        println("song stepper")
        if sender.value >= songListStepperValue {
            // add song
            var alert = UIAlertController(title: "Add song", message: "Enter song details:", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addTextFieldWithConfigurationHandler(titleConfigurationTextField)
            alert.addTextFieldWithConfigurationHandler(artistConfigurationTextField)
            alert.addTextFieldWithConfigurationHandler(albumConfigureationTextField)
            alert.addTextFieldWithConfigurationHandler(lengthConfigurationTextField)
            alert.addTextFieldWithConfigurationHandler(yearConfigurationTextField)
            alert.addTextFieldWithConfigurationHandler(composerConfigurationTextField)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:handleCancel))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
                println("User click Ok button")
                               
            }))
            self.presentViewController(alert, animated: true, completion: {
                println("completion block")
            })

            
        } else if sender.value <= songListStepperValue {
            // delete song
            let playlistIndex:Int = playlistPickerView.selectedRowInComponent(0)
            if playlistIndex == 0 {
                // remove song in current playlist and update UI
                let songIndex = songPickerView.selectedRowInComponent(0)
                let playlist:playlistModel = playlists.playlistDict[playlistPickerData[playlistIndex]]!
                let songTitle = playlist.accessSong(songIndex)?.title
                playlist.remove(songIndex)
                songList = playlist.listAllSongs()
                songPickerView.reloadAllComponents()
                
                // remove in other playlists
                for list in playlists.playlistDict {
                    list.1.removeByTitle(songTitle!)
                }
                
            }else{
                let playlist:playlistModel = playlists.playlistDict[playlistPickerData[playlistIndex]]!
                playlist.remove(songPickerView.selectedRowInComponent(0))
                songList = playlist.listAllSongs()
                songPickerView.reloadAllComponents()
            }
            
        }
    }
    
    
    //MARK UIAlertView Delegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        println("test")
    }
    
    
    //MARK alertView input
    
    func playlistConfigurationTextField(textField: UITextField!) {
        
        if let tField = textField {
            
            self.playlistTextField = textField!
            self.playlistTextField.placeholder = "Playlist Title"
        }
    }
    
    func titleConfigurationTextField(textField:UITextField!){
        if let tField = textField {
            
            self.titleTextField = textField!
            self.titleTextField.placeholder = "Song Title"
        }
    }
    
    func artistConfigurationTextField(textField:UITextField!) {
        if let tField = textField {
            
            self.artistTextField = textField!
            self.artistTextField.placeholder = "Artist Name"
        }
    }
    
    func albumConfigureationTextField(textField:UITextField!) {
        if let tField = textField {
            
            self.albumTextField = textField!
            self.albumTextField.placeholder = "Album Title"
        }
    }
    
    func lengthConfigurationTextField(textField:UITextField!) {
        if let tField = textField {
            
            self.lengthTextField = textField!
            self.lengthTextField.placeholder = "Song Length"
        }
    }
    
    func yearConfigurationTextField(textField:UITextField!){
        if let tField = textField {
            
            self.yearTextField = textField!
            self.yearTextField.placeholder = "Song Year"
        }
    }
    
    func composerConfigurationTextField(textField:UITextField!){
        if let tField = textField {
            
            self.composerTextField = textField!
            self.composerTextField.placeholder = "Composer Name"
        }
    }
    
    
    func handleCancel(alertView: UIAlertAction!) {
        println("Canceled add")
    }

}
