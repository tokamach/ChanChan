//
//  AppDelegate.swift
//  4chan-client
//
//  Created by Tom Hutchings on 24/03/2017.
//  Copyright © 2017 tokamach. All rights reserved.
//

import Cocoa
import Alamofire
import SwiftyJSON

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        let ch = ChanHelper.init();
        /*ch.loadThread(board: "c", threadID: 2863466, completionHandler: { res in
            print(res.posts[0].subject)
        })*/
        
        ch.loadCatalog(board: "c", completionHandler: { res in
            print(res.pages[0][0].subject)
        })
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

