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
        
        Alamofire.request("https://a.4cdn.org/c/thread/2863466.json", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let testThread = ChanThread(fromJSON: json)
                print(json["posts"][0]["sub"])
                print(testThread.posts[0].time);
            case .failure(let error):
                print(error)
            }
        }
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

