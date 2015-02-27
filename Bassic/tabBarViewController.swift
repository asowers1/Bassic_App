//
//  tabBarController.swift
//  Bassic
//
//  Created by Andrew Sowers on 2/20/15.
//  Copyright (c) 2015 Andrew Sowers. All rights reserved.
//

import Foundation
import UIKit
class tabBarViewController: UITabBarController {
    
    let playlistController = SharedPlaylistController.sharedInstance
    
    override func viewDidLoad() {
        self.tabBar.tintColor = uicolorFromHex(0xCC9933)
        
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

}