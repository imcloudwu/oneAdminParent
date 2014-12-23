//
//  FirstViewController.swift
//  oneAdminParent
//
//  Created by Cloud on 11/14/14.
//  Copyright (c) 2014 ischool. All rights reserved.
//

import UIKit

class AwardViewCtrl: UIViewController,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate {
    
    var _data:[Record]!
    var _displayData:[Record]!
    
    var actionSheet:UIActionSheet!
    
    //@IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var studentBtn: UIButton!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var labelAll: UILabel!
    @IBOutlet weak var labelMA: UILabel!
    @IBOutlet weak var labelMB: UILabel!
    @IBOutlet weak var labelMC: UILabel!
    @IBOutlet weak var labelDA: UILabel!
    @IBOutlet weak var labelDB: UILabel!
    @IBOutlet weak var labelDC: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _data = [Record]()
        _displayData = [Record]()
        
        Global.AdjustTableView(tableView)
        //Global.AdjustView(contentView)
        
        labelAll.layer.borderWidth = 1
        labelAll.layer.borderColor = UIColor.grayColor().CGColor
        labelMA.layer.borderWidth = 1
        labelMA.layer.borderColor = UIColor.grayColor().CGColor
        labelMB.layer.borderWidth = 1
        labelMB.layer.borderColor = UIColor.grayColor().CGColor
        labelMC.layer.borderWidth = 1
        labelMC.layer.borderColor = UIColor.grayColor().CGColor
        labelDA.layer.borderWidth = 1
        labelDA.layer.borderColor = UIColor.grayColor().CGColor
        labelDB.layer.borderWidth = 1
        labelDB.layer.borderColor = UIColor.grayColor().CGColor
        labelDC.layer.borderWidth = 1
        labelDC.layer.borderColor = UIColor.grayColor().CGColor
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
        
        if Global.CurrentChild == nil && Global.ChildList.count > 0{
            Global.CurrentChild = Global.ChildList[0]
        }
        if Global.CurrentChild != nil{
            GetData()
        }
    }
    
    @IBAction func segment_selected(sender: AnyObject) {
        _displayData.removeAll(keepCapacity: false)
        
        var before = [Record]()
        var after = [Record]()
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        var twoWeeksAgo = 14.days.ago
        
        for item in _data{
            if let date = dateFormatter.dateFromString(item.Date){
                
                let compareResult = twoWeeksAgo.compare(date)
                
                if compareResult == NSComparisonResult.OrderedAscending{
                    after.append(item)
                }
                else{
                    before.append(item)
                }
            }
        }
        
        if segment.selectedSegmentIndex == 0{
            _displayData = after
        }
        else{
            _displayData = before
        }
        
        var All = 0
        var Ma = 0
        var Mb = 0
        var Mc = 0
        var Da = 0
        var Db = 0
        var Dc = 0
        
        for item in _displayData{
            if let ma = item.MeritA?.toInt(){
                Ma += ma
            }
            if let mb = item.MeritB?.toInt(){
                Mb += mb
            }
            if let mc = item.MeritC?.toInt(){
                Mc += mc
            }
            if let da = item.DemeritA?.toInt(){
                Da += da
            }
            if let db = item.DemeritB?.toInt(){
                Db += db
            }
            if let dc = item.DemeritC?.toInt(){
                Dc += dc
            }
        }
        
        All += Ma + Mb + Mc + Da + Db + Dc
        
        labelAll.text = "\(All)"
        labelMA.text = "\(Ma)"
        labelMB.text = "\(Mb)"
        labelMC.text = "\(Mc)"
        labelDA.text = "\(Da)"
        labelDB.text = "\(Db)"
        labelDC.text = "\(Dc)"
        
        tableView.reloadData()
    }
    
    @IBAction func studentBtn_click(sender: AnyObject) {
        actionSheet.showInView(self.view)
    }
    
    // Called when a button is clicked. The view will be automatically dismissed after this call returns
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int){
        if buttonIndex > 0{
            Global.Loading.showActivityIndicator(self.view)
            Global.CurrentChild = Global.ChildList[buttonIndex - 1]
            GetData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return _displayData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        if _displayData[indexPath.row].isDemerit{
            var cell = tableView.dequeueReusableCellWithIdentifier("demeritCell") as DemeritCell
            cell.A.text = _displayData[indexPath.row].DemeritA
            cell.B.text = _displayData[indexPath.row].DemeritB
            cell.C.text = _displayData[indexPath.row].DemeritC
            cell.date.text = _displayData[indexPath.row].Date
            cell.reason.text = _displayData[indexPath.row].Reason
            return cell
        }
        else{
            var cell = tableView.dequeueReusableCellWithIdentifier("meritCell") as MeritCell
            cell.A.text = _displayData[indexPath.row].MeritA
            cell.B.text = _displayData[indexPath.row].MeritB
            cell.C.text = _displayData[indexPath.row].MeritC
            cell.date.text = _displayData[indexPath.row].Date
            cell.reason.text = _displayData[indexPath.row].Reason
            return cell
        }
        
    }
    
    func GetData(){
        _data.removeAll(keepCapacity: false)
        
        Global.CurrentChild.Con.SendRequest("discipline.GetChildDiscipline", body: "<Request><RefStudentId>\(Global.CurrentChild.ID)</RefStudentId></Request>") { (response) -> () in
            
            self.studentBtn.setTitle(Global.CurrentChild.Name, forState: UIControlState.Normal)
            
            var xml = SWXMLHash.parse(response)
            
            //println(NSString(data: response, encoding: NSUTF8StringEncoding))
            
            for disc in xml["Envelope"]["Body"]["Response"]["Discipline"] {
                
                if let flag = disc.element?.attributes["MeritFlag"] {
                    
                    if let date = disc.element?.attributes["OccurDate"] {
                        
                        var record:Record!
                        
                        var reason = disc["Reason"].element?.text
                        
                        if flag == "0" {
                            var demerit = disc["Demerit"]
                            var a = demerit.element?.attributes["A"]
                            var b = demerit.element?.attributes["B"]
                            var c = demerit.element?.attributes["C"]
                            
                            record = Record(MeritA: "", MeritB: "", MeritC: "", DemeritA: a, DemeritB: b, DemeritC: c, Date: date, Reason: reason, isDemerit: true)
                        }
                        else{
                            var merit = disc["Merit"]
                            var a = merit.element?.attributes["A"]
                            var b = merit.element?.attributes["B"]
                            var c = merit.element?.attributes["C"]
                            
                            record = Record(MeritA: a, MeritB: b, MeritC: c, DemeritA: "", DemeritB: "", DemeritC: "", Date: date, Reason: reason, isDemerit: false)
                        }
                        
                        self._data.append(record)
                        
                    }
                    
                }
            }
            
            self._data.sort{$0.Date > $1.Date}
            
            self.segment_selected(self)
            Global.Loading.hideActivityIndicator(self.view)
        }
    }
}
