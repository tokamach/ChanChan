//
//  util.swift
//  4chan-client
//
//  Created by Tom Hutchings on 24/03/2017.
//  Copyright © 2017 tokamach. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

struct ChanHelper
{
    static func loadImage(board: String, time: String, ext: String, completionHandler: @escaping (NSImage) -> Void)
    {
        let url = "https://i.4cdn.org/\(board)/\(time)\(ext)"
        Alamofire.request(url).validate().responseImage(completionHandler: { response in
            switch response.result
            {
            case .success(let value):
                completionHandler(value)
            case .failure(let error):
                print (error)
            }
        })
    }
    
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
    let number: NSNumber
    let time: String
    let date: String
    let resTo: NSNumber
    
    let name: String
    let subject: String
    let trip: String
    
    //file details
    let fileName: String
    let fileExt: String
    let fileMD5: String
    let fileSize: NSNumber
    let fileWidth: NSNumber
    let fileHeight: NSNumber
    let thumbWidth: NSNumber
    let thumbHeight: NSNumber
    
    //catalog stuff
    let lastReplies: Array<ChanPost>?
    
    let content: String;
    
    init(fromJSON postJSON: JSON)
    {
        number = postJSON["no"].numberValue
        time = postJSON["tim"].stringValue
        date = postJSON["now"].stringValue
        resTo = postJSON["resTo"].numberValue //needs conditional
        
        name = postJSON["name"].stringValue
        subject = postJSON["sub"].stringValue //needs conditional
        trip = postJSON["trip"].stringValue //needs conditional
        
        // all file stuff needs conditional
        fileName = postJSON["filename"].stringValue
        fileExt = postJSON["ext"].stringValue
        fileMD5 = postJSON["md5"].stringValue
        fileSize = postJSON["fsize"].numberValue
        fileHeight = postJSON["h"].numberValue
        fileWidth = postJSON["w"].numberValue
        thumbHeight = postJSON["tn_h"].numberValue
        thumbWidth = postJSON["tn_w"].numberValue
        
        content = postJSON["com"].stringValue //needs conditional
        
        lastReplies = nil
    }
    
    init(fromParams number: NSNumber, time: String, date: String, resTo: NSNumber, name: String,
         subject: String, trip: String, fileName: String, fileExt: String, fileMD5: String, fileSize: NSNumber,
         fileHeight: NSNumber, fileWidth: NSNumber, thumbHeight: NSNumber, thumbWidth: NSNumber, content: String)
    {
        self.number = number
        self.time = time
        self.date = date
        self.resTo = resTo
        
        self.name = name
        self.subject = subject
        self.trip = trip
        
        // all file stuff needs conditional
        self.fileName = fileName
        self.fileExt = fileExt
        self.fileMD5 = fileMD5
        self.fileSize = fileSize
        self.fileHeight = fileHeight
        self.fileWidth = fileWidth
        self.thumbHeight = thumbHeight
        self.thumbWidth = thumbWidth
        
        self.content = content
        
        self.lastReplies = nil
    }
    
    init(asDummy _: Any)
    {
        self.number = 0
        self.time = "1"
        self.date = "1/1/1980"
        self.resTo = 0
        
        self.name = "Anon"
        self.subject = "Some post"
        self.trip = ""
        
        // all file stuff needs conditional
        self.fileName = "weeby_photo"
        self.fileExt = ".png"
        self.fileMD5 = "123456789abcdef"
        self.fileSize = 128
        self.fileHeight = 512
        self.fileWidth = 512
        self.thumbHeight = 128
        self.thumbWidth = 128
        
        self.content = "This is a test post."
        
        self.lastReplies = nil

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
    
    //lel
    init() {
        pages = [[]]
    }
}
