//
//  SettingsViewController.swift
//  WakeOnLan
//
//  Created by Owner on 2015/12/15.
//  Copyright © 2015年 Yuta Aizawa. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView? = UITableView()
    
    var refreshCtrl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.tableView!.dataSource = self
        self.tableView!.delegate = self
        
        //Auto Layout
        self.tableView!.estimatedRowHeight = 113.0
        self.tableView!.rowHeight = UITableViewAutomaticDimension
        
        //Back button text
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        //Adapt to the left
        UITableView.appearance().separatorInset = UIEdgeInsetsZero
        
        //refresh
        refreshCtrl = UIRefreshControl()
        refreshCtrl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView!.addSubview(refreshCtrl)
    }
    
    //Refresh
    func refresh() {
        tableView!.reloadData()
        refreshCtrl.endRefreshing()
    }
    
    //TableView Settings
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return targetDataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Cell texts
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        
        let pcName = cell.viewWithTag(1) as! UILabel
        let ipAddress = cell.viewWithTag(2) as! UILabel
        let port = cell.viewWithTag(3) as! UILabel
        let mac = cell.viewWithTag(4) as! UILabel
        let broadcast = cell.viewWithTag(5) as! UILabel
        let flagSwitch = cell.viewWithTag(6) as! UISwitch
        
        let target: NSDictionary = targetDataArray[indexPath.row]
    
        pcName.text = "\(target["title"] as! String)"
        ipAddress.text = "IP       : " + "\(target["ip"] as! String)"
        port.text = "PORT : " + "\(target["port"] as! String)"
        mac.text = "MAC  : " + "\(target["mac"] as! String)"
        broadcast.text = "BROADCAST : "
        let cast = target["broadcast"] as! Bool
        if cast == true {
            broadcast.text = broadcast.text! + "ON"
        } else {
            broadcast.text = broadcast.text! + "OFF"
        }
        flagSwitch.on = target["flag"] as! Bool
        
        
        //Cell Backcolor
        let cellSelectedBgView = UIView()
        cellSelectedBgView.backgroundColor = UIColor.whiteColor()
        cell.selectedBackgroundView = cellSelectedBgView
        
        
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
    
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let target = targetDataArray[indexPath.row]
        let title = target["title"] as! String
        let ip = target["ip"] as! String
        let port = target["port"] as! String
        let mac = target["mac"] as! String
        let broadcast = target["broadcast"] as! Bool
        
        let edit = Target(title: "", ip: "", port: "", mac: "", broadcast: true, flag: true)
        editTargetData = edit.stringForNSDictionary(title, ip: ip, port: port, mac: mac, broadcast: broadcast, flag: true)
        
        editTargetIndex = indexPath
        
        self.performSegueWithIdentifier("toAddView",sender: nil)
    }

    
    //Switch
    @IBAction func onDidChangedSwitch(sender: UISwitch) {
        
        let point = self.tableView!.convertPoint(sender.frame.origin, fromView: sender.superview)
        if let indexPath = self.tableView!.indexPathForRowAtPoint(point) {
            changeSwitch(sender.on, indexPath: indexPath)
        }
    }

    private func changeSwitch(flag: Bool, indexPath: NSIndexPath) {
        
        let target: Target = Target(title: "", ip: "", port: "", mac: "", broadcast: true, flag: true)
        let dic = targetDataArray[indexPath.row]
        let data = target.stringForNSDictionary(dic["title"] as! String, ip: dic["ip"] as! String, port: dic["port"] as! String, mac: dic["mac"] as! String, broadcast: dic["broadcast"] as! Bool, flag: flag)
        targetDataArray[indexPath.row] = data
    }
    
    
    //Need Swipe
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {}
    
    //Swipe Settings
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") {
            (action, indexPath) in
        
            targetDataArray.removeAtIndex(indexPath.row)
                
            userDefaults.setValue(targetDataArray, forKey: "TargetDatas")
            self.tableView!.reloadData()
        }
        delete.backgroundColor = UIColor.redColor()
        
        return [delete]
    }
    
}