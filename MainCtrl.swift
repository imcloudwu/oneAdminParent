//
//  FirstViewController.swift
//  oneAdminParent
//
//  Created by Cloud on 11/14/14.
//  Copyright (c) 2014 ischool. All rights reserved.
//

import UIKit

class MainCtrl: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = Global.GreenColor
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //not allow change to landscape layout
    override func shouldAutorotate() -> Bool{
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientationMask.Portrait.rawValue.hashValue | UIInterfaceOrientationMask.PortraitUpsideDown.rawValue.hashValue
    }
    
    //override func touchesBegan(touches: NSSet, withEvent event: UIEvent){
        //println("Woops")
    //}
}