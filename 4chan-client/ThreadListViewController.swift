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
    @IBOutlet weak var boardTextField: NSTextField!
    
    var threadList: ChanCatalog?
    var currentBoard = "c"
    
    @IBAction func loadButtonPressed(_ sender: Any) {
        currentBoard = boardTextField.stringValue
        reloadCatalog()
        print(currentBoard)
        print(threadList?.pages[0][0].subject)
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }

    }
    
    func reloadCatalog()
    {
        ChanHelper.loadCatalog(board: currentBoard, completionHandler: { req in
            self.threadList = req
            self.tableView.delegate = self
            self.tableView.dataSource = self

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
