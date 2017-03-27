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
    @IBOutlet weak var threadViewController: ChanThreadView!
    
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

        reloadCatalog()
        configureThreadView()
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat
    {
        return 80
    }
    
    private func configureThreadView()
    {
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: 160.0, height: 140.0)
        //flowLayout.itemSize = NSSize(width: 0, height: 0)
        flowLayout.sectionInset = EdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        flowLayout.minimumInteritemSpacing = 20.0
        flowLayout.minimumLineSpacing = 20.0
        threadViewController.collectionViewLayout = flowLayout
    }
    
    func showThread(thread: ChanThread)
    {
        print(thread.posts[0].subject)
        threadViewController.reloadData()
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
            let threadNum = threadList!.pages[0][selected[0]].number
            ChanHelper.loadThread(board: currentBoard,
                                  threadID: threadNum,
                                  completionHandler: { res in
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
