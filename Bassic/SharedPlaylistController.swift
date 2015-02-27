/********************************************************************
*  SharedPlaylistController
*  Bassic
*  Date Modified: 2/17/2015
*  Purpose: this class creates and serves a shared playlistController
*  Input: NA
*  Output:NA
*  Created by Andrew Sowers on 2/3/15.
*  Copyright (c) 2015 Andrew Sowers. All rights reserved.
*********************************************************************/

import Foundation

/********************************************************************
//property _sharedPlaylistController
//Purpose: contains a playlistController
//Parameters: NA
//Return value: NA
//Properties modified: NA
//Precondition: NA
*********************************************************************/
private let _sharedPlaylistController:playlistController = playlistController()

class SharedPlaylistController {
    
    /********************************************************************
    //Computed property sharedInstance
    //Purpose: contains a shared playlistController
    //Parameters: NA
    //Return value: NA
    //Properties modified: NA
    //Precondition: NA
    *********************************************************************/
    class var sharedInstance: playlistController {
        return _sharedPlaylistController
    }
}
