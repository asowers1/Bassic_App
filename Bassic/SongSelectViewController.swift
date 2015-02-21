//
//  songSelectView.swift
//  Bassic
//
//  Created by Andrew Sowers on 2/21/15.
//  Copyright (c) 2015 Andrew Sowers. All rights reserved.
//

import Foundation
import UIKit

class songSelectViewController: UIViewController {
    var playlistTitle:String = String()
    
    override func viewDidLoad() {
        //self.navigationController?.navigationItem.title = self.playlistTitle
        self.navigationController?.navigationBar.tintColor = uicolorFromHex(0x111111)
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.06
        
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}