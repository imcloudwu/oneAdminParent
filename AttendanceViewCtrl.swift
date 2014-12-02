//
//  FirstViewController.swift
//  oneAdminParent
//
//  Created by Cloud on 11/14/14.
//  Copyright (c) 2014 ischool. All rights reserved.
//

import UIKit

class AttendanceViewCtrl: UIViewController,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate {
    
    var _data:[Attendance]!
    
    var actionSheet:UIActionSheet!
    
    var _displayData:[Attendance]!
    
    @IBOutlet weak var studentBtn: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Global.AdjustView(contentView)
        Global.AdjustTableView(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        _data = [Attendance]()
        _displayData = [Attendance]()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        actionSheet = UIActionSheet(title: "請選擇小孩", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil)
        actionSheet.actionSheetStyle = UIActionSheetStyle.BlackOpaque
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
        
        var before = [Attendance]()
        var after = [Attendance]()
        
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
        
        var sum = 0
        for item in _displayData{
            sum += item.Count
        }
        
        sumLabel.text = "缺曠總節次:\(sum)"
        
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
        var cell:AbsenceCell = tableView.dequeueReusableCellWithIdentifier("absCell") as AbsenceCell
        cell.absenceType.text = "  假別:\(_displayData[indexPath.row].Type)(\(_displayData[indexPath.row].Count))"
        cell.date.text = "日期:\(_displayData[indexPath.row].Date)"
        cell.period.text = "節次:\(_displayData[indexPath.row].Desc)"
        
        return cell
    }
    
    func GetData(){
        _data.removeAll(keepCapacity: false)
        
        Global.CurrentChild.Con.SendRequest("absence.GetChildAttendance", body: "<Request><RefStudentId>\(Global.CurrentChild.ID)</RefStudentId></Request>") { (response) -> () in
            
            self.studentBtn.setTitle(Global.CurrentChild.Name, forState: UIControlState.Normal)
            var temp = Dictionary<String,Attendance>()
            var xml = SWXMLHash.parse(response)
            
            //println(NSString(data: response, encoding: NSUTF8StringEncoding))
            
            for att in xml["Envelope"]["Body"]["Response"]["Attendance"] {
                if let date = att.element?.attributes["OccurDate"]{
                    
                    //println("OccurDate:\(date)")
                    for elem in att["Detail"]["Period"] {
                        
                        if let type = elem.element?.attributes["AbsenceType"]{
                            
                            var key = "\(date)_\(type)"
                            
                            if let period = elem.element?.text {
                                
                                if temp[key] == nil{
                                    temp[key] = Attendance(Type: type, Date: date, Desc: period, Count: 1)
                                }
                                else{
                                    temp[key]?.Count++;
                                    temp[key]?.Desc += ",\(period)"
                                }
                            }
                        }
                    }
                }
            }
            
            for (date,value) in temp{
                self._data.append(value)
            }
            
            self._data.sort{$0.Date > $1.Date}
            
            self.segment_selected(self)
            Global.Loading.hideActivityIndicator(self.view)
        }
    }
}

