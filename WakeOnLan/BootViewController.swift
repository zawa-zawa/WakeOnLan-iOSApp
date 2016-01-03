//
//  BootViewController.swift
//  WakeOnLan
//
//  Created by Owner on 2015/12/15.
//  Copyright © 2015年 Yuta Aizawa. All rights reserved.
//

import Foundation
import UIKit
import CocoaAsyncSocket

class BootViewController: UIViewController, GCDAsyncUdpSocketDelegate {

    var socket: GCDAsyncUdpSocket!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func bootBtn(sender: AnyObject) {
        
        if targetDataArray.count > 0 {
            for var i = 0; i < targetDataArray.count; i++ {
                
                let target = targetDataArray[i]
                if target["flag"] as! Bool == true {
                
                    var ip: String = ""
                    var port: UInt16 = 0
                    var mac: [UInt8] = [0]
                    
                    if target["ip"] as? String != nil {
                        ip = target["ip"] as! String
                    }
                    if target["port"] as? UInt16 != nil {
                        port = target["port"] as! UInt16
                    }
                    if target["mac"] as? String != nil {
                        mac = self.textToMac(target["mac"] as! String)
                    }
       
                    sendPacket(ip, PORT: port, MAC: mac)
                    print("PacketSend: \(target["title"])")
                } else {
                    showAlert("Error", message: "The target has not been selected.")
                }
            } //end for
        } else {
            showAlert("Error", message: "You must input Target of SettingsTab.")
        }
    
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
    
    func showAlert(title: String?, message: String?) {
        
        let alertController = UIAlertController(title: title, message: (message ?? ""), preferredStyle: .Alert)
        let dafaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(dafaultAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
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