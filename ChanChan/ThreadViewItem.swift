//
//  ThreadViewItem.swift
//  4chan-client
//
//  Created by Tom Hutchings on 27/03/2017.
//  Copyright © 2017 tokamach. All rights reserved.
//

import Cocoa

class ThreadViewItem: NSCollectionViewItem {
    
    /*
    var imageFile: ImageFile?
    {
        didSet {
            guard viewLoaded else { return }
            if let imageFile = imageFile {
                imageView?.image = imageFile.thumbnail
                textField?.stringValue = imageFile.fileName
            } else {
                imageView?.image = nil
                textField?.stringValue = ""
            }
        }
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
    }
    
}
