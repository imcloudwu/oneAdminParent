//
//  FirstViewController.swift
//  oneAdminParent
//
//  Created by Cloud on 11/14/14.
//  Copyright (c) 2014 ischool. All rights reserved.
//

import UIKit

class MessageViewCtrl: UIViewController,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate {
    
    var _data:[Msg]!
    var _displayData:[Msg]!
    var refreshControl:UIRefreshControl!
    var lastIndex = 0
    
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var content: UIView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //content.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        
        //content.setNeedsLayout()
        //content.layoutIfNeeded()
        
        self.view.layoutSubviews()
        
        //Global.AdjustView(content)
        //Global.AdjustTableView(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        _data = [Msg]()
        _displayData = [Msg]()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.addTarget(self, action: "Refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        Refresh()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segment_selected(sender: AnyObject) {
        
        _displayData.removeAll(keepCapacity: false)
        
        if segment.selectedSegmentIndex == 0 || segment.selectedSegmentIndex == 1{
            _displayData = _data
        }
        else{
            //_displayData = []
        }
        
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return _displayData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell:MessageCell = tableView.dequeueReusableCellWithIdentifier("msgCell") as! MessageCell
        
//        cell.cellView.layer.borderWidth = 2
//        cell.cellView.layer.borderColor = Global.GreenColor.CGColor
//        
//        cell.cellView.layer.cornerRadius = 5
        
        cell.schoolName.text = _displayData[indexPath.row].SchoolName
        cell.unit.text = _displayData[indexPath.row].Unit
        cell.date.text = _displayData[indexPath.row].Date
        cell.subject.text = "  \(_displayData[indexPath.row].Subject)"
        cell.content.text = _displayData[indexPath.row].Content
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var nextView = self.storyboard?.instantiateViewControllerWithIdentifier("msgView") as! MsgView
//        nextView.subject = "[\(_data[indexPath.row].Unit)] \(_data[indexPath.row].Subject)"
//        nextView.content = _data[indexPath.row].Content
        nextView.obj = _displayData[indexPath.row]
        
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    //重新取得公告訊息
    func Refresh(){
        
        self._data.removeAll(keepCapacity: false)
        self.tableView.reloadData()
        
        var finish = [String]()
        
        for child in Global.ChildList{
            
            if !contains(finish,child.Con.AccessPoint){
                //同學校的小孩就不再查了
                finish.append(child.Con.AccessPoint)
                
                child.Con.SendRequest("im.GetMessage", body: "<Request><LastUid>0</LastUid></Request>"){data in
//                    println("==================")
//                    println(NSString(data: data, encoding: NSUTF8StringEncoding))
                    
                    var xml = SWXMLHash.parse(data)
                    for msg in xml["Envelope"]["Body"]["Response"]["Message"]{
                        
                        var LastUpdate = msg["LastUpdate"].element?.text
                        var SchoolName = msg["Content"]["Message"]["From"]["School"].element?.text
                        var Unit = msg["Content"]["Message"]["From"]["Unit"].element?.text
                        var Subject = msg["Content"]["Message"]["Subject"].element?.text
                        var Content = msg["Content"]["Message"]["Content"].element?.text
                        
                        self._data.append(Msg(Date: LastUpdate, SchoolName: SchoolName, Unit: Unit, Subject: Subject, Content: Content))
                    }
                    
                    self._data.sort{$0.Date > $1.Date}
                    
                    self.segment_selected(self)
                    
                    //self.tableView.reloadData()
                }
            }
        }
        
        self.refreshControl.endRefreshing()
    }
}