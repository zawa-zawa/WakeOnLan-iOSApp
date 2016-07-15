//
//  Data.swift
//  WakeOnLan
//
//  Created by Owner on 2015/12/28.
//  Copyright © 2015年 Yuta Aizawa. All rights reserved.
//

import Foundation
import UIKit

struct Target {
    
    var title: String
    var ip: String
    var port: String
    var mac: String
    var broadcast: Bool
    var flag: Bool

    func targetDatasNSDictionaryToTarget(dictionary: NSDictionary?) -> Target {
        
        let titleValue = dictionary?["title"] as? String ?? "Title"
        let ipValue = dictionary?["ip"] as? String ?? "192.168.0.1"
        let portValue = dictionary?["port"] as? String ?? "50000"
        let macValue = dictionary?["mac"] as? String ?? "AA:AA:AA:AA:AA:AA"
        let broadcastFlag = dictionary?["broadcast"] as? Bool ?? true
        let sendFlag = dictionary?["flag"] as? Bool ?? true
        
        return Target(title: titleValue, ip: ipValue, port: portValue, mac: macValue, broadcast: broadcastFlag, flag: sendFlag)
    }
    
    func stringForNSDictionary(title: String, ip: String, port: String, mac: String, broadcast: Bool, flag: Bool) -> NSDictionary {
        
        let dictionary: NSDictionary = [
            "title": title,
            "ip": ip,
            "port": port,
            "mac": mac,
            "broadcast" : broadcast,
            "flag": flag
        ]
        return dictionary
    }   
}

//NSUserDefaults
let userDefaults = NSUserDefaults.standardUserDefaults()

//TargetData
var targetDataArray: [NSDictionary] = []

//Copying data
var editTargetData: NSDictionary? = nil
var editTargetIndex: NSIndexPath? = nil

