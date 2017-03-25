//
//  ThreadListViewController.swift
//  4chan-client
//
//  Created by Tom Hutchings on 25/03/2017.
//  Copyright © 2017 tokamach. All rights reserved.
//

import Cocoa

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
        
        if let cell = tableView.make(withIdentifier: "ThreadCellID", owner: nil) as? NSTableCellView
        {
            cell.textField?.stringValue = threadList!.pages[0][row].subject
            return cell
        }
        
        return nil
    }
}
