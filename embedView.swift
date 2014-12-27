//
//  FirstViewController.swift
//  oneAdminParent
//
//  Created by Cloud on 11/14/14.
//  Copyright (c) 2014 ischool. All rights reserved.
//

import UIKit

class embedView: UIViewController {
    
    
    @IBOutlet weak var passing: UILabel!
    
    @IBOutlet weak var domain: UILabel!
    
    @IBOutlet weak var course: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //test.text = "XXX"
        self.view.layer.masksToBounds = true
        self.view.layer.cornerRadius = 5
        Global.EmbedView = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}