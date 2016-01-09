//
//  HowToUse.swift
//  WakeOnLan
//
//  Created by Owner on 2016/01/03.
//  Copyright © 2016年 Yuta Aizawa. All rights reserved.
//

import UIKit

class HouToUseViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textLabel.text = "" +
            "A simple Wake-On-Lan application.\n\n" +
            "You will need to configure your computer to enable WakeOnLan first.\n\n" +
            "Tapping the Boot button, it will send the packet to the target that are turned on.\n" +
            "Please update by pulling down when you add the target. To delete You can delete it by swiping the cell to the left.\n"
    }
}