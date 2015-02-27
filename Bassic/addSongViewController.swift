//
//  addSongViewController.swift
//  Bassic
//
//  Created by Andrew Sowers on 2/22/15.
//  Copyright (c) 2015 Andrew Sowers. All rights reserved.
//

import UIKit
import Foundation
class addSongViewController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var playlistController = SharedPlaylistController.sharedInstance
    var didSelectYearPicker:Bool = false
    var didSelectLengthPicker:Bool = false
    
    // for song date
    var thousandsList:[String] = []
    var hundredsList:[String] = []
    var tensList:[String] = []
    var onesList:[String] = []
    
    // for song length
    var minuteList:[String] = []
    var secondList:[String] = []
    
    var yearValue:String = String()
    var lengthValue:String = String()
    
    var minuteValue:String = String()
    var secondValue:String = String()
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var albumField: UITextField!
    @IBOutlet weak var artistField: UITextField!
    @IBOutlet weak var composerField: UITextField!
    
    @IBOutlet weak var yearPickerView: UIPickerView!
    @IBOutlet weak var lengthPickerView: UIPickerView!
    
    override func viewDidLoad()
    {
        self.yearPickerView.dataSource = self
        self.yearPickerView.delegate = self
        
        self.lengthPickerView.dataSource = self
        self.lengthPickerView.delegate = self
        
        
        for index in 0...2 {
            thousandsList.append(String(index))
        }
        
        for index in 0...9 {
            hundredsList.append(String(index))
        }
        
        for index in 0...9 {
            tensList.append(String(index))
        }
        
        for index in 0...9 {
            onesList.append(String(index))
        }
        
        for index in 0...59 {
            minuteList.append(String(index))
            
        }
        
        for index in 0...59 {
            if index < 10 {
                secondList.append(String("0\(index)"))
            }else{
                secondList.append(String(index))
            }
        }
        
        self.navigationController?.navigationBar.tintColor = uicolorFromHex(0xe1a456)
        
        /*
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

        */
        
    }
    /********************************************************************
    *Function:
    *Purpose:
    *Parameters:
    *Return:
    *Properties modified:
    *Precondition:
    ********************************************************************/
    override func viewWillAppear(animated: Bool) {
    }
    /********************************************************************
    *Function:uicolorFromHex
    *Purpose:change color from hex to UIColor
    *Parameters:animated bool
    *Return:N/A
    *Properties modified:N/A
    *Precondition:N/A
    ********************************************************************/
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.06
        
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    /********************************************************************
    *Function:pickerView
    *Purpose:
    *Parameters:
    *Return:
    *Properties modified:
    *Precondition:
    ********************************************************************/
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            self.yearValue = ""
            for i in 0...3 {
                self.yearValue += String(yearPickerView.selectedRowInComponent(i))
            }
            self.didSelectYearPicker = true
            
        } else if pickerView.tag == 1 {
            self.lengthValue = ""
            for i in 0...1 {
                if i == 0 {
                    self.minuteValue = String(lengthPickerView.selectedRowInComponent(i))
                }else if i == 1 {
                    self.secondValue = String(lengthPickerView.selectedRowInComponent(i))
                }
            }
            self.didSelectLengthPicker = true
        }
    }
    /********************************************************************
    *Function:numberOfComponentsInPickerView
    *Purpose:count the number of components in picker view
    *Parameters:UIPickerView
    *Return:int
    *Properties modified:N/A
    *Precondition:N/A
    ********************************************************************/
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if pickerView.tag == 0 {
            return 4
        }
        else if pickerView.tag == 1 {
            return 3
        }
        else {
            return 0
        }
    }

/********************************************************************
*Function: pickerView
*Purpose: sets up numer of rows per tag and component
*Parameters: pickerView: UIPickerView, numberofRowsInComponent component: Int
*Return: number of rows: Int
*Properties modified: picker view properties
*Precondition: Class must conform to UIPickerView delegate
********************************************************************/
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0  && component == 0{
            return thousandsList.count
        } else if pickerView.tag == 0 && component == 1 {
            return hundredsList.count
        } else if pickerView.tag == 0 && component == 2 {
            return tensList.count
        } else if pickerView.tag == 0 && component == 3 {
            return onesList.count
        } else if pickerView.tag == 1  && component == 0{
            return minuteList.count
        } else if pickerView.tag == 1 && component == 1 {
            return secondList.count
        }
        else{
            return 0
            
        }
    }
    
/********************************************************************
*Function: pickerView
*Purpose: sets up title of rows per tag and component
*Parameters: pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int
*Return: title for row: String
*Properties modified: picker view properties
*Precondition: Class must conform to UIPickerView delegate
********************************************************************/
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView.tag == 0  && component == 0{
            return thousandsList[row]
        } else if pickerView.tag == 0 && component == 1 {
            return hundredsList[row]
        } else if pickerView.tag == 0 && component == 2 {
            return tensList[row]
        } else if pickerView.tag == 0 && component == 3 {
            return onesList[row]
        } else if pickerView.tag == 1  && component == 0{
            return minuteList[row]
        } else if pickerView.tag == 1 && component == 1 {
            return secondList[row]
        }
        else{
            return "derp"
            
        }
    }
    
/********************************************************************
*Function: tapToResignKeyboards
*Purpose: resign first responder of all keyboards
*Parameters: sender: AnyObject
*Return: Void.
*Properties modified: NA
*Precondition: NA
********************************************************************/
    @IBAction func tapToResignKeyboards(sender: AnyObject) {
        self.titleField.resignFirstResponder()
        self.albumField.resignFirstResponder()
        self.artistField.resignFirstResponder()
        self.composerField.resignFirstResponder()
    }
    
/********************************************************************
*Function: addSong
*Purpose: add a new song
*Parameters: sender: AnyObject
*Return: number of rows: Int
*Properties modified: picker view properties
*Precondition: Class must conform to UIPickerView delegate
********************************************************************/
    @IBAction func addSong(sender: AnyObject) {
        if titleField.text != "" && artistField.text != "" && albumField.text != "" && composerField.text != "" && self.didSelectLengthPicker == true && self.didSelectYearPicker == true{
            
            // get playlist model "All songs"
            var playlist:playlistModel = self.playlistController.accessPlaylist("All songs")
            if playlist.checkIfSongExists(titleField.text,artist: artistField.text){
                let alert = UIAlertView(title: "Hey Buddy", message: "You can't add a song with the same title and artist in a playlist", delegate: self, cancelButtonTitle: "Okay")
                alert.show()
                return
            }
            
            // length in seconds
            let lengthInSeconds:Int = (minuteValue.toInt()! * 60) + secondValue.toInt()!
            
            // create new song
            let newSong:Song = Song(name: titleField.text, artist: artistField.text, album: albumField.text, year: self.yearValue.toInt()!, composer: composerField.text, length: lengthInSeconds)
            
            // add new song to playlist
            playlist.add(newSong)
            if let navController = self.navigationController {
                navController.popViewControllerAnimated(true)
            }
        }else{
            let alert = UIAlertView(title: "Hey Buddy", message: "Aren't you forgetting a few fields?", delegate: self, cancelButtonTitle: "It seems you're right")
            alert.show()
        }
    }
}