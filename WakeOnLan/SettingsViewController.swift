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
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //Adapt to the left
        UITableView.appearance().separatorInset = UIEdgeInsets.zero
        
        //refresh
        refreshCtrl = UIRefreshControl()
        refreshCtrl.addTarget(self, action: #selector(SettingsViewController.refresh), for: UIControlEvents.valueChanged)
        tableView!.addSubview(refreshCtrl)
    }
    
    //Refresh
    func refresh() {
        tableView!.reloadData()
        refreshCtrl.endRefreshing()
    }
    
    //TableView Settings
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return targetDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Cell texts
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        let pcName = cell.viewWithTag(1) as! UILabel
        let ipAddress = cell.viewWithTag(2) as! UILabel
        let port = cell.viewWithTag(3) as! UILabel
        let mac = cell.viewWithTag(4) as! UILabel
        let broadcast = cell.viewWithTag(5) as! UILabel
        let flagSwitch = cell.viewWithTag(6) as! UISwitch
        
        let target: NSDictionary = targetDataArray[(indexPath as NSIndexPath).row]
    
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
        flagSwitch.isOn = target["flag"] as! Bool
        
        
        //Cell Backcolor
        let cellSelectedBgView = UIView()
        cellSelectedBgView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = cellSelectedBgView
        
        
        //Adapt to the left
        if cell.responds(to: #selector(getter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        
        if cell.responds(to: #selector(getter: UIView.preservesSuperviewLayoutMargins)) {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        if cell.responds(to: #selector(getter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
        
        return cell
    }
    
    func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {

        let target = targetDataArray[(indexPath as NSIndexPath).row]
        let title = target["title"] as! String
        let ip = target["ip"] as! String
        let port = target["port"] as! String
        let mac = target["mac"] as! String
        let broadcast = target["broadcast"] as! Bool
        
        let edit = Target(title: "", ip: "", port: "", mac: "", broadcast: true, flag: true)
        editTargetData = edit.stringForNSDictionary(title, ip: ip, port: port, mac: mac, broadcast: broadcast, flag: true)
        
        editTargetIndex = indexPath
        
        self.performSegue(withIdentifier: "toAddView",sender: nil)
    }

    
    //Switch
    @IBAction func onDidChangedSwitch(_ sender: UISwitch) {
        
        let point = self.tableView!.convert(sender.frame.origin, from: sender.superview)
        if let indexPath = self.tableView!.indexPathForRow(at: point) {
            changeSwitch(sender.isOn, indexPath: indexPath)
        }
    }

    fileprivate func changeSwitch(_ flag: Bool, indexPath: IndexPath) {
        
        let target: Target = Target(title: "", ip: "", port: "", mac: "", broadcast: true, flag: true)
        let dic = targetDataArray[(indexPath as NSIndexPath).row]
        let data = target.stringForNSDictionary(dic["title"] as! String, ip: dic["ip"] as! String, port: dic["port"] as! String, mac: dic["mac"] as! String, broadcast: dic["broadcast"] as! Bool, flag: flag)
        targetDataArray[(indexPath as NSIndexPath).row] = data
    }
    
    
    //Need Swipe
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {}
    
    //Swipe Settings
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") {
            (action, indexPath) in
        
            targetDataArray.remove(at: (indexPath as NSIndexPath).row)
                
            userDefaults.setValue(targetDataArray, forKey: "TargetDatas")
            self.tableView!.reloadData()
        }
        delete.backgroundColor = UIColor.red
        
        return [delete]
    }
    
}
