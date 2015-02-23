//
//  songViewController.swift
//  Bassic
//
//  Created by Andrew Sowers on 2/22/15.
//  Copyright (c) 2015 Andrew Sowers. All rights reserved.
//

import Foundation
import UIKit

class songViewController : UIViewController {
    
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
    
    
}