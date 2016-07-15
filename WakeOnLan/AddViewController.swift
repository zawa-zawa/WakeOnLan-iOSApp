//
//  AddViewController.swift
//  WakeOnLan
//
//  Created by Owner on 2015/12/15.
//  Copyright © 2015年 Yuta Aizawa. All rights reserved.
//

import Foundation
import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ipTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var macTextField: UITextField!
    @IBOutlet weak var broadcastSwitch: UISwitch!
    
    @IBAction func tapScreen(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    @IBAction func saveBtn(sender: AnyObject) {
        if save() == true {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    @IBAction func closeBtn(sender: AnyObject) {
        editInit()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    var target: Target = Target(title: "", ip: "", port: "", mac: "", broadcast: true, flag: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if editTargetIndex != nil {
            self.nameTextField.text = editTargetData!["title"] as? String
            self.ipTextField.text = editTargetData!["ip"] as? String
            self.portTextField.text = editTargetData!["port"] as? String
            self.macTextField.text = editTargetData!["mac"] as? String
            self.broadcastSwitch.on = editTargetData!["broadcast"] as! Bool
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func save() -> Bool {
        
        if targetAddToArray() == true {
            userDefaults.setValue(targetDataArray, forKey: "TargetDatas")
            return true
        } else {
            showAlert("Error", message: "The respect is omitted.")
        }
        
        return false
    }
    
    private func targetAddToArray() -> Bool {
    
        if nameTextField.text != "" && ipTextField.text != "" && portTextField.text != "" && macTextField.text != "" {
            let targetData = self.target.stringForNSDictionary(nameTextField.text!, ip: ipTextField.text!, port: portTextField.text!, mac: macTextField.text!, broadcast: broadcastSwitch.on, flag: true)
            
            if editTargetIndex != nil {
                targetDataArray[editTargetIndex!.row] = targetData
            } else {
                targetDataArray.append(targetData)
            }
            
            editInit()
            
            return true
        } else {
            print("return false")
        }
        return false
    }
    
    private func editInit() {
        editTargetIndex = nil
        editTargetData = nil
    }
    
    func showAlert(title: String?, message: String?) {
        
        let alertController = UIAlertController(title: title, message: (message ?? ""), preferredStyle: .Alert)
        let dafaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(dafaultAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}
