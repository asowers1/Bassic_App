//
//  bassicViewController.swift
//  Bassic
//
//  Created by Andrew Sowers on 2/7/15.
//  Copyright (c) 2015 Andrew Sowers. All rights reserved.
//

import UIKit
import Foundation

class bassicViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate  {


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
    
    

    
    var playlists: playlistController = playlistController()
    var playlistPickerData:[String] = []
    var songList:[String] = []
    
    func buildTestSet() {
        
        // initial playlists
        playlists.addPlaylist("rock")
        playlists.addPlaylist("running")
        playlists.addPlaylist("classical")
    
    
        // initial songs
        playlists.addSongToPlaylist("All songs", songTitle: "Portway", songArtist: "Land Observations", songAlbum: "Roman Roads IV-XI", songLength: 3.34, songYear: 2012, songComposer: "Land Observations")
        playlists.addSongToPlaylist("All songs", songTitle: "Brandonburg Concerto No.1 in G, BWV 1048: 3. Allegro", songArtist: "Johann Sebastian Bach", songAlbum: "Bach Brandenburg Concertos; Orchestra Suites", songLength: 4.44, songYear: 1988, songComposer: "Johann Sebastian Bach")
        
        
        
        // access intial song listing
        
        songList = playlists.accessPlaylist("All songs").listAllSongs()
        
        let initialSong:songModel = playlists.accessPlaylist("All songs").accessSong(0)
        println(initialSong.artist)
        titleLabel.text = initialSong.title
        artistLabel.text = initialSong.artist
        albumLabel.text = initialSong.album
        lengthLabel.text = String(format: "%.02f",initialSong.length)
        yearLabel.text = String(format: "%d", initialSong.year)
        composerLabel.text = initialSong.composer
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playlistPickerView.dataSource = self
        playlistPickerView.delegate = self
        songPickerView.dataSource = self
        songPickerView.delegate = self
        
        self.buildTestSet()
        playlistPickerData = playlists.getPlaylistList()
        
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
            let currentSong:songModel = selectedPlaylist.accessSong(row)
            titleLabel.text = currentSong.title
            artistLabel.text = currentSong.artist
            albumLabel.text = currentSong.album
            lengthLabel.text = String(format: "%.02f", currentSong.length)
            yearLabel.text = String(format: "%d", currentSong.year)
            composerLabel.text = currentSong.composer
        }
    }
    
    @IBAction func playlistStepperCallback(sender: UIStepper) {
        
    }
    
    
    @IBAction func songStepperCallback(sender: UIStepper) {
        
    }
}
