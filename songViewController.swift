//
//  songViewController.swift
//  Bassic
//
//  Created by Andrew Sowers on 2/22/15.
//  Copyright (c) 2015 Andrew Sowers. All rights reserved.
//

import Foundation
import UIKit

class songViewController : UIViewController, UIAlertViewDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var composerLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    
    var name:String = String()
    var artist:String = String()
    var album:String = String()
    var year:String = String()
    var composer:String = String()
    var length:String = String()
    
    var lengthInSeconds:Int = Int()
    
    let playlists: playlistController = SharedPlaylistController.sharedInstance
    
    // playlist input field
    var playlistTextField:UITextField = UITextField()
    
    // album input field
    var albumTextField:UITextField = UITextField()
    
    override func viewDidLoad(){
        nameLabel.text = name
        artistLabel.text = artist
        albumLabel.text = album
        yearLabel.text = year
        composerLabel.text = composer
        lengthLabel.text = length
        self.navigationController?.navigationBar.tintColor = uicolorFromHex(0xe1a456)
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.06
        
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    @IBAction func addToPlaylist(sender: AnyObject) {
        // lookup song
        // check to see if in playlist already
            // alert(alerady added)
        // else
            // add to playlist
        
        var alert = UIAlertController(title: "Add song to playlist", message: "Enter playlist name:", preferredStyle: UIAlertControllerStyle.Alert)
        
        var innerAlertPlaylist = UIAlertController(title: "Error", message: "Song is already in playlist", preferredStyle: UIAlertControllerStyle.Alert)
        innerAlertPlaylist.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler:nil))

        var invalidPlaylistAlert = UIAlertController(title: "Error", message: "Invalid playlist", preferredStyle: UIAlertControllerStyle.Alert)
        invalidPlaylistAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler:nil))
        
        alert.addTextFieldWithConfigurationHandler(playlistConfigurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
            println("User click Ok button")
            println(self.playlistTextField.text)
            if self.playlists.checkIfPlaylistExists(self.playlistTextField.text) {
                if self.playlists.accessPlaylist(self.playlistTextField.text).checkIfSongExistsByAlbum(self.name, artist: self.artist, album: self.album){
                    
                    self.presentViewController(innerAlertPlaylist, animated: true, completion: nil)
                }else{
                    println("add to new playlist")
                    self.playlists.addSongToPlaylist(self.playlistTextField.text, songTitle: self.name, songArtist: self.artist, songAlbum: self.album, songLength: String(self.lengthInSeconds), songYear: self.year, songComposer: self.composer)
                }

            }else{
                self.presentViewController(invalidPlaylistAlert, animated: true, completion: nil)
            }
            
            
        }))
        self.presentViewController(alert, animated: true, completion: {
            println("completion block")
        })

        
        //
    }
    @IBAction func addToAlbum(sender: AnyObject) {
        // lookup song
        // check to see if in album already
            // alert(already added)
        //else
            // create new song
            // add to playlist structure
        var alert = UIAlertController(title: "Add song to album", message: "Enter album name:", preferredStyle: UIAlertControllerStyle.Alert)
        
        var innerAlertAlbum = UIAlertController(title: "Error", message: "Song is already in album", preferredStyle: UIAlertControllerStyle.Alert)
        innerAlertAlbum.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler:nil))
        
        alert.addTextFieldWithConfigurationHandler(albumConfigurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
            println("User click Ok button")
            println(self.playlistTextField.text)
            
            var addFlag:Bool = false; 
        
                println("add to new album song")
                self.playlists.addSongToPlaylist("All songs", songTitle: self.name, songArtist: self.artist, songAlbum: self.albumTextField.text, songLength: String(self.lengthInSeconds), songYear: self.year, songComposer: self.composer)
                
            
            
        }))
        self.presentViewController(alert, animated: true, completion: {
            println("completion block")
            
        })

        
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
    //Function albumConfigurationTextField
    //Purpose: text field for add playlist UIAlertView
    //Parameters: UITextField - textField
    //Return value: NA
    //Properties modified: NA
    //Precondition: NA
    *********************************************************************/
    func albumConfigurationTextField(textField: UITextField!) {
        
        if let tField = textField {
            
            self.albumTextField = textField!
            self.albumTextField.placeholder = "Album Title"
        }
    }
    @IBAction func helpAlert(sender: AnyObject) {
        
        var alert = UIAlertController(title: "Info", message: "Add to playlist will add a song to a playlist\nAdd to album will create a new song with the new desired album name", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler:nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
}