//
//  ThreadListViewController.swift
//  4chan-client
//
//  Created by Tom Hutchings on 25/03/2017.
//  Copyright © 2017 tokamach. All rights reserved.
//

import Cocoa
import Alamofire
import AlamofireImage

class ThreadListViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    
    var threadList: ChanCatalog?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        ChanHelper.loadCatalog(board: "c", completionHandler: { req in
            self.threadList = req
            self.tableView.delegate = self
            self.tableView.dataSource = self
        })
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 80
    }
}

extension ThreadListViewController: NSTableViewDataSource
{
    func numberOfRows(in tableView: NSTableView) -> Int {
        if (self.threadList!.pages.count > 0)
        {
            return self.threadList!.pages[0].count
        }
        else
        {
            return 0
        }
    }
}

extension ThreadListViewController: NSTableViewDelegate
{
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard (threadList?.pages[0][row]) != nil else
        {
            return nil
        }
        
        if let cell = tableView.make(withIdentifier: "ThreadCellID", owner: nil) as? ThreadTableCellView
        {
            cell.textField?.stringValue = threadList!.pages[0][row].subject
            
            ChanHelper.loadImage(board: "c",
                                 time: threadList!.pages[0][row].time,
                                 ext: threadList!.pages[0][row].fileExt,
                                 completionHandler: { res in
                cell.previewImageView?.image = res
            })
            
            return cell
        }
        
        return nil
    }
}
