//
//  ThreadListViewController.swift
//  4chan-client
//
//  Created by Tom Hutchings on 25/03/2017.
//  Copyright © 2017 tokamach. All rights reserved.
//

import Cocoa

class ThreadListViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}

extension ThreadListViewController: NSOutlineViewDataSource
{
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        return 0
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let thread = item as? ChanThread
        {
            return thread.posts[index]
        }
        
        var r = ChanThread()
        ChanHelper.loadCatalog(board: "c", completionHandler: { res in
            let id = res.pages[0][0].number
            ChanHelper.loadThread(board: "c", threadID: id, completionHandler: { res in
                r = res
            })
        })
        
        return r
        
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let thread = item as? ChanThread
        {
            //return thread.posts.count > 0
            return false
        }
        
        return false
    }
}

extension ThreadListViewController: NSOutlineViewDelegate
{
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView?
    {
        var view: NSTableCellView?
        
        if let thread = item as? ChanThread {
            view = outlineView.make(withIdentifier: "ThreadCell", owner: self) as? NSTableCellView
            
            if let textField = view?.textField {
                textField.stringValue = thread.posts[0].subject
                textField.sizeToFit()
            }
        }
        
        return view
    }
}
