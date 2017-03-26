//
//  ChanViewController.swift
//  4chan-client
//
//  Created by Tom Hutchings on 25/03/2017.
//  Copyright © 2017 tokamach. All rights reserved.
//

import Cocoa
import Alamofire
import AlamofireImage

class ChanViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    
    var threadList: ChanCatalog?
    var currentBoard = "c"
    
    func reloadCatalog()
    {
        ChanHelper.loadCatalog(board: currentBoard, completionHandler: { req in
            self.threadList = req
            self.tableView.delegate = self
            self.tableView.dataSource = self
            DispatchQueue.main.async
            {
                self.tableView.reloadData()

            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        reloadCatalog()
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat
    {
        return 80
    }
}

extension ChanViewController: NSTableViewDataSource
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

extension ChanViewController: NSTableViewDelegate
{
    func tableViewSelectionDidChange(_ notification: Notification) {
        if let table = notification.object as? NSTableView
        {
            let selected = table.selectedRowIndexes.map { Int($0) }
            print(threadList!.pages[0][selected[0]].subject)
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard (threadList!.pages.count > 0) else
        {
            return nil
        }
        
        if let cell = tableView.make(withIdentifier: "ThreadCellID", owner: nil) as? ThreadTableCellView
        {
            cell.textField?.stringValue = threadList!.pages[0][row].subject
            cell.postContentLabel?.stringValue = threadList!.pages[0][row].content
            
            ChanHelper.loadImage(board: currentBoard,
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