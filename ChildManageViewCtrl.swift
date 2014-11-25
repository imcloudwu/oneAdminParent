//
//  ChildManageViewCtrl.swift
//  oneAdminParent
//
//  Created by Cloud on 11/24/14.
//  Copyright (c) 2014 ischool. All rights reserved.
//

import UIKit

class ChildManageViewCtrl: UIViewController,UIActionSheetDelegate,UIAlertViewDelegate {
    
    var actionSheet:UIActionSheet!
    var child:Child!
    var childIndex:Int!
    
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Global.AdjustView(contentView)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        actionSheet = UIActionSheet(title: "請選擇小孩", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil)
        for child in Global.ChildList{
            actionSheet.addButtonWithTitle(child.Name)
        }
    }
    
    // Called when a button is clicked. The view will be automatically dismissed after this call returns
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int){
        if buttonIndex > 0{
            
            childIndex = buttonIndex - 1
            child = Global.ChildList[childIndex]
            
            let alert = UIAlertView()
            alert.delegate = self
            alert.title = "確認刪除？"
            alert.message = "即將刪除  \(child.Name)"
            alert.addButtonWithTitle("確認")
            alert.addButtonWithTitle("取消")
            alert.show()
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if buttonIndex == 0{
            child.Con.SendRequest("main.RemoveChild", body: "<Request><StudentParent><StudentID>\(child.ID)</StudentID></StudentParent></Request>") { (response) -> () in
                
                Global.ChildList.removeAtIndex(self.childIndex)
                self.viewWillAppear(false)
            }
        }
    }
    
    
    @IBAction func deleteChild(sender: AnyObject) {
        actionSheet.showInView(self.view)
    }
}