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
    @IBOutlet weak var threadImageView: NSImageView!
    
    var threadList: ChanCatalog?
    var currentBoard = "c"
    
    var curThreadIndex = 0
    var curPostIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadCatalog()
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
            return $0
        }
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.modifierFlags.intersection(.deviceIndependentFlagsMask) {
        case [.command] where event.characters == "j":
            threadPrev()
            showThread
            break
            
        case [.command] where event.characters == "k":
            threadNext()
            break
            
        default:
            break
        }
    }
    
    func threadNext()
    {
        if (curPostIndex - 1 < threadList?.pages[curThreadIndex].count)
        {
            curPostIndex += 1
        }
    }
    
    func theadPrev()
    {
        if (curPostIndex > 0)
        {
            curPostIndex -= 1
        }
    }
    
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
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat
    {
        return 80
    }
    
    func showThread(thread: ChanThread)
    {
        print(thread.posts[0].subject)
        ChanHelper.loadImage(board: currentBoard,
                             time: thread.posts[curPostIndex].time,
                             ext: thread.posts[0].fileExt,
                             completionHandler: { res in
                                self.threadImageView?.image = res
        })
        //threadViewController.reloadData()
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
            let threadNum = threadList!.pages[0][selected[posInThread]].number
            
            ChanHelper.loadThread(board: currentBoard,
                                  threadID: threadNum,
                                  completionHandler: { res in
                                    self.curPostIndex = 0
                                    self.showThread(thread: res)
            })
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard (threadList!.pages.count > 0) else
        {
            return nil
        }
        
        if let cell = tableView.make(withIdentifier: "ThreadCellID", owner: nil) as? ThreadTableCellView
        {
            curThreadIndex = row

            cell.textField?.stringValue = threadList!.pages[0][curThreadIndex].subject
            cell.postContentLabel?.stringValue = threadList!.pages[0][curThreadIndex].content
            
            ChanHelper.loadImage(board: currentBoard,
                                 time: threadList!.pages[0][curThreadIndex].time,
                                 ext: threadList!.pages[0][curThreadIndex].fileExt,
                                 completionHandler: { res in
                cell.previewImageView?.image = res
            })
            
            return cell
        }
        
        return nil
    }
}
