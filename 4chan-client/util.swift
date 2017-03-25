//
//  util.swift
//  4chan-client
//
//  Created by Tom Hutchings on 24/03/2017.
//  Copyright © 2017 tokamach. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct ChanHelper
{
    static func loadCatalog(board: String, completionHandler: @escaping (ChanCatalog) -> Void)
    {
        let url = "https://a.4cdn.org/\(board)/catalog.json"
        Alamofire.request(url).validate().responseJSON {response in
            switch response.result {
            case .success(let value):
                completionHandler(ChanCatalog(fromJSON: JSON(value)))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func loadThread(board: String, threadID: NSNumber, completionHandler: @escaping (ChanThread) -> Void)
    {
        let url = "https://a.4cdn.org/\(board)/thread/\(threadID).json"
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                completionHandler(ChanThread(fromJSON: JSON(value)))
            case .failure(let error):
                print(error)
            }
        }
    }
}

// A post on 4chan
struct ChanPost
{
    //post details
    let number: NSNumber;
    let time: String;
    let resTo: NSNumber;
    
    let name: String;
    let subject: String;
    let trip: String;
    
    //file details
    let fileName: String;
    let fileExt: String;
    let fileMD5: String;
    let fileSize: NSNumber;
    let fileWidth: NSNumber;
    let fileHeight: NSNumber;
    let thumbWidth: NSNumber;
    let thumbHeight: NSNumber;
    
    //catalog stuff
    let lastReplies: Array<ChanPost>?
    
    let content: String;
    
    init(fromJSON postJSON: JSON)
    {
        number = postJSON["no"].numberValue;
        time = postJSON["now"].stringValue;
        resTo = postJSON["resTo"].numberValue; //needs conditional
        
        name = postJSON["name"].stringValue;
        subject = postJSON["sub"].stringValue; //needs conditional
        trip = postJSON["trip"].stringValue; //needs conditional
        
        // all file stuff needs conditional
        fileName = postJSON["filename"].stringValue;
        fileExt = postJSON["ext"].stringValue;
        fileMD5 = postJSON["md5"].stringValue;
        fileSize = postJSON["fsize"].numberValue;
        fileHeight = postJSON["h"].numberValue;
        fileWidth = postJSON["w"].numberValue;
        thumbHeight = postJSON["tn_h"].numberValue;
        thumbWidth = postJSON["tn_w"].numberValue;
        
        content = postJSON["com"].stringValue; //needs conditional
        
        lastReplies = nil
    }
}

// A thread on 4chan
struct ChanThread
{
    let posts: Array<ChanPost>;
    
    init()
    {
        posts = []
    }
    
    init(fromJSON threadJSON: JSON)
    {
        posts = threadJSON["posts"].arrayValue.map({
            ChanPost(fromJSON: $0)
        });
    }
}

//fucking guess
struct ChanCatalog
{
    var pages: Array<Array<ChanPost>>
    
    init(fromJSON catJSON: JSON)
    {
        //ＦＵＮＣＴＩＯＮＡＬ ＰＲＯＧＲＡＭＭＩＮＧ
        pages = catJSON.arrayValue.map({
            $0["threads"].arrayValue.map({
                ChanPost(fromJSON: $0)
            })
        })
    }
}
