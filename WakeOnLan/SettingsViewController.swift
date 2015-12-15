//
//  SettingsViewController.swift
//  WakeOnLan
//
//  Created by Owner on 2015/12/15.
//  Copyright © 2015年 Yuta Aizawa. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //Auto Layout
        self.tableView.estimatedRowHeight = 93.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        //Back button text
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        //Adapt to the left
        UITableView.appearance().separatorInset = UIEdgeInsetsZero
    }
    

    //TableView Settings
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        
        let pcName = cell.viewWithTag(1) as! UILabel
        let ipAddress = cell.viewWithTag(2) as! UILabel
        let port = cell.viewWithTag(3) as! UILabel
        let mac = cell.viewWithTag(4) as! UILabel
    
        pcName.text = ""
        ipAddress.text = "IP       : " + ""
        port.text = "PORT : " + ""
        mac.text = "MAC  : " + ""
    
        
        //Adapt to the left
        if cell.respondsToSelector("separatorInset") {
            cell.separatorInset = UIEdgeInsetsZero
        }
        
        if cell.respondsToSelector("preservesSuperviewLayoutMargins") {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        if cell.respondsToSelector("layoutMargins") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        
        return cell
    }
    
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        print("drlected cell")
    }
    
    
}