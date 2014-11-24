//
//  Global.swift
//  App
//
//  Created by Cloud on 10/9/14.
//  Copyright (c) 2014 Cloud. All rights reserved.
//

import Foundation
import UIKit

struct Global{
    static var connector:Connector!
    static var ChildList:[Child] = [Child]()
    static var CurrentChild:Child!
    static var Selector:SelectStudentView!
    static var LVC:LoginViewCtrl!
    static var DSNS:[String]!
    static var GreenColor:UIColor = UIColor(red: 122/255, green: 201/255, blue: 13/255, alpha: 1)
    
    static func GetChildList(sender:UIViewController!){
        LVC.GetChildList(sender)
    }
    
    static func AdjustView(content:UIView){
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenHeight = screenSize.height
        
        if screenHeight >= 736{
            content.frame.offset(dx: 19, dy: 0)
        }
        else if screenHeight <= 568{
            content.frame.offset(dx: -28, dy: 0)
        }
    }
    
    static func AdjustTableView(content:UIView){
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenHeight = screenSize.height
        
        if screenHeight == 480{
            content.frame.size.height += -187
        }
        else if screenHeight == 568{
            content.frame.size.height += -99
        }
    }
}

class SelectStudentView: NSObject,UIActionSheetDelegate{
    
    var actionSheet:UIActionSheet!
    
    class func GetInstance() -> SelectStudentView {
        struct Static {
            static var instance: SelectStudentView?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = SelectStudentView()
        }
        
        return Static.instance!
    }
    
    private override init(){
        super.init()
        actionSheet = UIActionSheet()
        actionSheet.delegate = self
        actionSheet.title = "請選擇小孩"
        
        for child in Global.ChildList{
            actionSheet.addButtonWithTitle(child.Name)
        }
    }
    
    func Show(view:UIView){
        actionSheet.showInView(view)
    }
    
    // Called when a button is clicked. The view will be automatically dismissed after this call returns
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int){
        Global.CurrentChild = Global.ChildList[buttonIndex]
    }
}

//class PrompView:NSObject,UIPickerViewDataSource,UIPickerViewDelegate{
//
//    var promp:UIAlertView!
//    var picker:UIPickerView!
//
//    class func GetInstance() -> PrompView {
//
//        struct Static {
//            static var instance: PrompView?
//            static var token: dispatch_once_t = 0
//        }
//
//        dispatch_once(&Static.token) {
//            Static.instance = PrompView()
//        }
//
//        return Static.instance!
//    }
//
//    private override init(){
//        super.init()
//        promp = UIAlertView()
//        picker = UIPickerView()
//
//        picker.delegate = self
//        picker.dataSource = self
//        promp.title = "選擇小孩"
//        promp.setValue(picker, forKey: "accessoryView")
//        promp.addButtonWithTitle("確認")
//        promp.delegate = self
//    }
//
//    func Show(){
//        picker.reloadAllComponents()
//        promp.show()
//    }
//
//    // returns the number of 'columns' to display.
//    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
//        return 1
//    }
//
//    // returns the # of rows in each component..
//    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
//        return Global.ChildList.count
//    }
//
//    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!{
//        return Global.ChildList[row].Name
//    }
//
//    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
//        Global.CurrentChild = Global.ChildList[row]
//    }
//}

func GetDoorWayURL(dsns:String) -> String{
    return "http://dsns.ischool.com.tw/dsns/dsns/DS.NameService.GetDoorwayURL?content=%3Ca%3E\(dsns)%3C/a%3E"
}

struct Child{
    var AccessPoint:String!
    var ID:String!
    var Name:String!
    var Con:Connector!
}

struct Attendance{
    var Type:String
    var Date:String
    var Desc:String
    var Count:Int
}

struct SYSM{
    var SchoolYear:String
    var Semester:String
    var Content:String
}

struct Record{
    var MeritA:String!
    var MeritB:String!
    var MeritC:String!
    var DemeritA:String!
    var DemeritB:String!
    var DemeritC:String!
    var Date:String!
    var Reason:String!
    var isDemerit:Bool
}

struct SemsScore{
    var Name:String!
    var Score:String!
    var Credit:String!
    var IsXiodin:Bool
    var IsRequire:Bool
    var IsReach:Bool
    var IsLearning:Bool
}

struct Msg{
    var Date:String!
    var SchoolName:String!
    var Unit:String!
    var Subject:String!
    var Content:String!
}

extension Int {
    var days:Int {
        return 60*60*24*self
    }
    var ago:NSDate {
        return NSDate().dateByAddingTimeInterval(-Double(self))
    }
}

//Connector Sample Code
/*
con.SendRequest("absence.GetAbsenceNames", body: "") { (response) -> () in
var xml = SWXMLHash.parse(response)
for elem in xml["Envelope"]["Body"]["data"] {
println(elem["name"].element?.text)
}
}

con.SendRequest("evaluateScoreSH.GetClassExamScore", body: "<Request><StudentID>55137</StudentID><SchoolYear>99</SchoolYear><Semester>1</Semester><ExamName>第一次月考</ExamName><Subject>閱讀指導</Subject></Request>") { (response) -> () in
var xml = SWXMLHash.parse(response)
for elem in xml["Envelope"]["Body"]["Exam"] {
println(elem["ref_student_id"].element?.text)
//                println(elem["score"].element?.text)
//                println(elem["exam_name"].element?.text)
//                println(elem["course_name"].element?.text)
//                println(elem["subject"].element?.text)
//                println(elem["school_year"].element?.text)
//                println(elem["semester"].element?.text)
}
}

con.SendRequest("main.GetSchoolInfo", body: "") { (response) -> () in
var xml = SWXMLHash.parse(response)
for elem in xml["Envelope"]["Body"]["SchoolInfo"] {
println(elem["ChineseName"].element?.text)
println(elem["EnglishName"].element?.text)
println(elem["Address"].element?.text)
println(elem["Code"].element?.text)
println(elem["Fax"].element?.text)
}
}
*/