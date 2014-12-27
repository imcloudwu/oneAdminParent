//
//  SMScoreViewCtrl.swift
//  oneAdminParent
//
//  Created by Cloud on 11/24/14.
//  Copyright (c) 2014 ischool. All rights reserved.
//

import UIKit

class SMScoreViewCtrl: UIViewController,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate {
    
    var _data:[SYSM]!
    var _displayData:[SemsScore]!
    
    var actionSheet:UIActionSheet!
    var sysmActionSheet:UIActionSheet!
    
    //@IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var totalView: UIView!
    
    @IBOutlet weak var studentBtn: UIButton!
    @IBOutlet weak var sysmBtn: UIButton!
    
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var require: UILabel!
    @IBOutlet weak var unrequire: UILabel!
    @IBOutlet weak var budinR: UILabel!
    @IBOutlet weak var budinUR: UILabel!
    @IBOutlet weak var xiodinR: UILabel!
    @IBOutlet weak var xiodinUR: UILabel!
    @IBOutlet weak var learn: UILabel!
    
    @IBOutlet weak var embedView: UIView!
    
    
    @IBAction func studentBtn_click(sender: AnyObject) {
        actionSheet.showInView(self.view)
    }
    @IBAction func sysmBtn_click(sender: AnyObject) {
        sysmActionSheet.showInView(self.view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        summaryView.layer.cornerRadius = 5
        totalView.layer.cornerRadius = 5
        
        _data = [SYSM]()
        _displayData = [SemsScore]()
        
        //Global.AdjustTableView(tableView)
        //Global.AdjustView(contentView)
        
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
    
    // Called when a button is clicked. The view will be automatically dismissed after this call returns
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int){
        
        if actionSheet == self.actionSheet{
            if buttonIndex > 0{
                
                Global.Loading.showActivityIndicator(self.view)
                
                Global.CurrentChild = Global.ChildList[buttonIndex - 1]
                GetData()
            }
        }
        else if actionSheet == sysmActionSheet{
            if buttonIndex > 0{
                
                self.sysmBtn.setTitle("\(_data[buttonIndex - 1].SchoolYear)學年度第\(_data[buttonIndex - 1].Semester)學期", forState: UIControlState.Normal)
                println(_data[buttonIndex - 1].Content)
                
                _displayData.removeAll(keepCapacity: false)
                var tempDetail = [SemsScore]()
                var tempTitle = [SemsScore]()
                
                var xml = SWXMLHash.parse("<root>\(_data[buttonIndex - 1].Content)</root>")
                
                var underScoreCount = 0
                var learnDomainScore = ""
                var courseLearnScore = ""
                var isJH = false
                //先判斷是否為國中資料
                if let hasLearnDomainScore = xml["root"]["LearnDomainScore"].element?.text{
                    //println(hasLearnDomainScore)
                    learnDomainScore = hasLearnDomainScore
                    isJH = true
                }
                if let hasourseLearnScore = xml["root"]["CourseLearnScore"].element?.text{
                    //println(hasLearnDomainScore)
                    courseLearnScore = hasourseLearnScore
                    isJH = true
                }
                
                //create smscore
                for subj in xml["root"]["SemesterSubjectScoreInfo"]["Subject"]{
                    
                    //變數初始化
                    var name:String!
                    var score:String!
                    var credit:String!
                    var domain:String!
                    var isXiodin = false
                    var isReach = false
                    var isRequire = false
                    var isLearning = false
                    var isTitle = false
                    
                    name = subj.element?.attributes["科目"]
                    
                    if(isJH){
                        score = subj.element?.attributes["成績"]
                        let p:String! = subj.element?.attributes["節數"]
                        let c:String! = subj.element?.attributes["權數"]
                        domain = subj.element?.attributes["領域"]
                        credit = "\(p) / \(c)"
                    }
                    else{
                        score = subj.element?.attributes["原始成績"]
                        credit = subj.element?.attributes["開課學分數"]
                        isXiodin = subj.element?.attributes["修課校部訂"] == "校訂" ? true : false
                        isReach = subj.element?.attributes["是否取得學分"] == "是" ? true : false
                        isRequire = subj.element?.attributes["修課必選修"] == "必修" ? true : false
                        isLearning = subj.element?.attributes["開課分項類別"] == "實習科目" ? true : false
                    }
                    
                    var ss = SemsScore(Name: name, Score: score, Credit: credit, IsXiodin: isXiodin, IsRequire: isRequire, IsReach: isReach, IsLearning: isLearning, IsJH: isJH, Domain: domain, IsTitle: isTitle)
                    
                    tempDetail.append(ss)
                }
                
                //create title
                for subj in xml["root"]["Domains"]["Domain"]{
                    
                    //變數初始化
                    var name:String!
                    var score:String!
                    var credit:String!
                    var domain:String!
                    var isXiodin = false
                    var isReach = false
                    var isRequire = false
                    var isLearning = false
                    var isTitle = true
                    
                    domain = subj.element?.attributes["領域"]
                    score = subj.element?.attributes["成績"]
                    let p:String! = subj.element?.attributes["節數"]
                    let c:String! = subj.element?.attributes["權數"]
                    credit = "\(p) / \(c)"
                
                    var ss = SemsScore(Name: name, Score: score, Credit: credit, IsXiodin: isXiodin, IsRequire: isRequire, IsReach: isReach, IsLearning: isLearning, IsJH: isJH, Domain: domain, IsTitle: isTitle)
                    
                    tempTitle.append(ss)
                }
                
                embedView.hidden = true
                if(isJH){
                    embedView.hidden = false
                    
                    _displayData.append(SemsScore(Name: "column", Score: "", Credit: "", IsXiodin: false, IsRequire: false, IsReach: false, IsLearning: false, IsJH: false, Domain: "column", IsTitle: true))
                    
                    for tt in tempTitle{
                        
                        //累計不合格的領域數目
                        if tt.Score.floatValue < 60{
                            underScoreCount++
                        }
                        
                        _displayData.append(tt)
                        for td in tempDetail{
                            if(td.Domain == tt.Domain){
                                _displayData.append(td)
                            }
                        }
                    }
                }
                else{
                    embedView.hidden = true
                    _displayData = tempDetail
                }
                
                //Set embed view value
                Global.EmbedView.passing.text = "\(underScoreCount)"
                Global.EmbedView.domain.text = learnDomainScore
                Global.EmbedView.course.text = courseLearnScore
                
                var totalGet = 0
                var total = 0
                var require = 0
                var unrequire = 0
                var budinR = 0
                var budinUR = 0
                var xiodinR = 0
                var xiodinUR = 0
                var learn = 0
                
                for data in _displayData{
                    
                    if data.Credit != nil{
                        if let credit = data.Credit.toInt(){
                            
                            total += credit
                            
                            if data.IsXiodin && data.IsRequire{
                                xiodinR += credit
                                require += credit
                            }
                            else if data.IsXiodin{
                                xiodinUR += credit
                                unrequire += credit
                            }
                            else if data.IsRequire{
                                budinR += credit
                                require += credit
                            }
                            else{
                                budinUR += credit
                                unrequire += credit
                            }
                            
                            if data.IsReach == true{
                                totalGet += credit
                            }
                            
                            if data.IsLearning {
                                learn += credit
                            }
                        }
                    }
                    
                }
                
                self.total.text = "\(totalGet) / \(total)"
                self.require.text = "\(require)"
                self.unrequire.text = "\(unrequire)"
                self.budinR.text = "\(budinR)"
                self.budinUR.text = "\(budinUR)"
                self.xiodinR.text = "\(xiodinR)"
                self.xiodinUR.text = "\(xiodinUR)"
                self.learn.text = "\(learn)"
                
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return _displayData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        if _displayData[indexPath.row].IsTitle{
            
            if _displayData[indexPath.row].Domain == "column" && _displayData[indexPath.row].Domain == "column"{
                var cell = tableView.dequeueReusableCellWithIdentifier("columnCell") as UITableViewCell
                //cell.contentView.layer.masksToBounds = true
                cell.contentView.layer.cornerRadius = 5
                return cell
            }
            
            var cell = tableView.dequeueReusableCellWithIdentifier("jhsmScoreTitleCell") as JHSMScoreTitleCell
            cell.domain.text = _displayData[indexPath.row].Domain
            cell.credit.text = "\(_displayData[indexPath.row].Credit)"
            cell.score.text = "\(_displayData[indexPath.row].Score)"
            
            cell.score.textColor = UIColor.blackColor()
            if _displayData[indexPath.row].Score.floatValue < 60{
                cell.score.textColor = UIColor.redColor()
            }
            
            return cell
        }
        else if _displayData[indexPath.row].IsJH{
            var cell = tableView.dequeueReusableCellWithIdentifier("jhsmScoreCell") as JHSMScoreCell
            cell.subject.text = _displayData[indexPath.row].Name
            cell.credit.text = "\(_displayData[indexPath.row].Credit)"
            cell.score.text = "\(_displayData[indexPath.row].Score)"
            
            cell.score.textColor = UIColor.blackColor()
            if _displayData[indexPath.row].Score.floatValue < 60{
                cell.score.textColor = UIColor.redColor()
            }
            
            return cell
        }
        else{
            var cell = tableView.dequeueReusableCellWithIdentifier("shsmScoreCell") as SHSMScoreCell
            cell.subject.text = _displayData[indexPath.row].Name
            cell.credit.text = "學分 \(_displayData[indexPath.row].Credit)"
            cell.score.text = "成績 \(_displayData[indexPath.row].Score)"
            
            var require = _displayData[indexPath.row].IsRequire == true ? "必修" : "選修"
            var type = _displayData[indexPath.row].IsXiodin == true ? "校訂" : "部訂"
            
            cell.type.text = "\(type)\(require)"
            
            if _displayData[indexPath.row].IsReach{
                cell.cellView.backgroundColor = UIColor(red: 217.0/255.0, green: 1, blue: 196.0/255.0, alpha: 0.8)
                //cell.backgroundColor = UIColor(red: 217.0/255.0, green: 1, blue: 196.0/255.0, alpha: 0.8)
            }
            else{
                cell.cellView.backgroundColor = UIColor(red: 255.0/255.0, green: 228.0/255.0, blue: 225.0/255.0, alpha: 0.8)
                //cell.backgroundColor = UIColor(red: 255.0/255.0, green: 228.0/255.0, blue: 225.0/255.0, alpha: 0.8)
            }
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if _displayData[indexPath.row].IsTitle{
            if _displayData[indexPath.row].Domain == "column" && _displayData[indexPath.row].Domain == "column"{
                return 20
            }
            return 20
        }
        else if _displayData[indexPath.row].IsJH{
            return 20
        }
        else{
            return 55
        }
        
    }
    
    func GetData(){
        _data.removeAll(keepCapacity: false)
        _displayData.removeAll(keepCapacity: false)
        self.tableView.reloadData()
        
        self.total.text = "\(0) / \(0)"
        self.require.text = "\(0)"
        self.unrequire.text = "\(0)"
        self.budinR.text = "\(0)"
        self.budinUR.text = "\(0)"
        self.xiodinR.text = "\(0)"
        self.xiodinUR.text = "\(0)"
        self.learn.text = "\(0)"
        
        Global.CurrentChild.Con.SendRequest("semesterScoreSH.GetChildSemsScore", body: "<Request><ScoreInfo/><RefStudentId>\(Global.CurrentChild.ID)</RefStudentId></Request>") { (response) -> () in
            
            self.studentBtn.setTitle(Global.CurrentChild.Name, forState: UIControlState.Normal)
            
            //println(NSString(data: response, encoding: NSUTF8StringEncoding))
            
            var xml = SWXMLHash.parse(response)
            for elem in xml["Envelope"]["Body"]["Response"]["SemsSubjScore"] {
                if let schoolYear = elem.element?.attributes["SchoolYear"]{
                    if let semester = elem.element?.attributes["Semester"]{
                        if let content = elem["ScoreInfo"].element?.text{
                            self._data.append(SYSM(SchoolYear: schoolYear, Semester: semester, Content: content))
                        }
                    }
                }
            }
            
            self.sysmActionSheet = UIActionSheet(title: "請選擇學年度學期", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil)
            
            for sysm in self._data{
                self.sysmActionSheet.addButtonWithTitle("\(sysm.SchoolYear)學年度第\(sysm.Semester)學期")
            }
            
            if self._data.count > 0{
                self.sysmBtn.setTitle("\(self._data[0].SchoolYear)學年度第\(self._data[0].Semester)學期", forState: UIControlState.Normal)
                self.actionSheet(self.sysmActionSheet,clickedButtonAtIndex: 1)
            }
            else{
                self.sysmBtn.setTitle("查無學期成績資料", forState: UIControlState.Normal)
            }
            
            Global.Loading.hideActivityIndicator(self.view)
        }
    }
    
}