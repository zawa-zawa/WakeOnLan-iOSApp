//
//  BootViewController.swift
//  WakeOnLan
//
//  Created by Owner on 2015/12/15.
//  Copyright © 2015年 Yuta Aizawa. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CocoaAsyncSocket

class BootViewController: UIViewController, GCDAsyncUdpSocketDelegate {

    let ip = "221.119.216.202"
    let port: UInt16 = 4900
    let mac: [UInt8] = [0x94, 0xDE, 0x80, 0x6D, 0x76, 0x42]
    var socket: GCDAsyncUdpSocket!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func bootBtn(sender: AnyObject) {
//        sendPacket(ip, PORT: port, MAC: mac)
    }
    
    func sendPacket(IP: String, PORT: UInt16, MAC: [UInt8]){

        //Setup connection
        socket = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        try! socket.connectToHost(IP, onPort: PORT)
        
        //Create packet data
        var data: [UInt8] = [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]
        for var i = 0; i < 16; i++ {
            data += MAC
        }
        
        let packet = NSData(bytes: data, length: data.count)
        
        //Send
        socket.sendData(packet, withTimeout: 2, tag: 0)
    }
    
    
    //String -> UInt8 MacAddress
    
    func stringToHex(str: String) -> UInt8 {
        
        var hex: UInt32 = 0x0;
        let scanner: NSScanner = NSScanner(string: str)
        scanner.scanHexInt(&hex)
        
        let uInt8Hex = UInt8(hex)
        
        return uInt8Hex
    }
    
    func textToMac(text: String) -> [UInt8] {
        
        var array: [String] = []
        var returnArray: [UInt8] = []
        
        if let _ = text.rangeOfString(":") {
            array = text.componentsSeparatedByString(":")
        }
        else if let _ = text.rangeOfString("-") {
            array = text.componentsSeparatedByString("-")
        }
        else if let _ = text.rangeOfString(",") {
            array = text.componentsSeparatedByString(",")
        }
        
        for var i = 0; i < array.count; i++ {
            returnArray.append(stringToHex(array[i]))
        }
        
        return returnArray
    }

}