//
//  FirstViewController.swift
//  oneAdminParent
//
//  Created by Cloud on 11/14/14.
//  Copyright (c) 2014 ischool. All rights reserved.
//

import UIKit

class jhViewCtrl: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let alert = UIAlertView()
        alert.delegate = self
        alert.title = "系統提示"
        alert.message = "加入成功"
        alert.addButtonWithTitle("OK")
        alert.show()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}