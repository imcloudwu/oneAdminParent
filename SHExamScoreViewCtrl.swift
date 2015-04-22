//
//  FirstViewController.swift
//  oneAdminParent
//
//  Created by Cloud on 11/14/14.
//  Copyright (c) 2014 ischool. All rights reserved.
//

import UIKit

class SHExamScoreViewCtrl: UIViewController,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource {
    
    var _data:[ExamScore]!
    var _displayData:[ExamScore]!
    
    var _sysm:[SYSM]!
    var _examDic:Dictionary<String, [String]>!
    
    var _currentSY:String!
    var _currentSM:String!
    
    var actionSheet:UIActionSheet!
    var sysmActionSheet:UIActionSheet!
    var examActionSheet:UIActionSheet!
    var _isJH:Bool!
    var _isHS:Bool!
    
    let _upArrow = UIImage(named: "arrow_up.png")
    let _downArrow = UIImage(named: "arrow_down.png")
    let _emptyArrow = UIImage()
    
    @IBOutlet weak var studentBtn: UIButton!
    @IBOutlet weak var sysmBtn: UIButton!
    @IBOutlet weak var examBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func studentBtn_click(sender: AnyObject) {
        actionSheet.showInView(self.view)
    }
    
    @IBAction func sysmBtn_click(sender: AnyObject) {
        sysmActionSheet.showInView(self.view)
    }
    
    @IBAction func examBtn_click(sender: AnyObject) {
        examActionSheet.showInView(self.view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _data = [ExamScore]()
        _displayData = [ExamScore]()
        
        _sysm = [SYSM]()
        
        _examDic = Dictionary<String,[String]>()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
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
            PrepareToGetData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func PrepareToGetData(){
        
        Global.Loading.showActivityIndicator(self.view)
        CheckDSNS(Global.CurrentChild.DSNS)
        
        self._sysm.removeAll(keepCapacity: false)
        self._data.removeAll(keepCapacity: false)
        self._examDic.removeAll(keepCapacity: false)
        
        if _isJH == true{
            GetJHData()
        }
        else{
            GetSHData()
        }
    }
    
    //國中成績
    func GetJHData(){
        
        Global.CurrentChild.Con.SendRequest("evaluateScoreJH.GetExamScore", body: "<Request><Condition><StudentID>\(Global.CurrentChild.ID)</StudentID></Condition></Request>") { (response) -> () in
            
            self.studentBtn.setTitle(Global.CurrentChild.Name, forState: UIControlState.Normal)
            
            //println(NSString(data: response, encoding: NSUTF8StringEncoding))
            
            var xml = SWXMLHash.parse(response)
            
            for sems in xml["Envelope"]["Body"]["ExamScoreList"]["Seme"] {
                
                let sy:String! = sems.element?.attributes["SchoolYear"]
                let sm:String! = sems.element?.attributes["Semester"]
                
                self._sysm.append(SYSM(SchoolYear: sy, Semester: sm, Content: "\(sy)學年度第\(sm)學期"))
                
                if self._examDic["\(sy)#\(sm)"] == nil{
                    self._examDic["\(sy)#\(sm)"] = [String]()
                }
                
                for course in sems["Course"]{
                    
                    let domain:String! = course.element?.attributes["Domain"]
                    let subject:String! = course.element?.attributes["Subject"]
                    let credit:String! = course.element?.attributes["Credit"]
                    let percentage:String! = course["FixTime"]["Extension"]["ScorePercentage"].element?.text
                    
                    //新增平時成績資料
                    if let ordinarilyScore = course["FixExtension"]["Extension"]["OrdinarilyScore"].element?.text {
                        self._data.append(ExamScore(SchoolYear: sy, Semester: sm, Subject: subject, Exam: "平時成績", Domain: domain, Score: "0", AssignmentScore: "0", Credit: credit, State: "fair", Avg: ordinarilyScore))
                        
                        //平時成績項目
                        if !self._isHS && !contains(self._examDic["\(sy)#\(sm)"]!, "平時成績"){
                            self._examDic["\(sy)#\(sm)"]?.append("平時成績")
                        }
                    }
                    
                    for exam in course["Exam"]{
                        
                        let examName:String! = exam.element?.attributes["ExamName"]
                        let score:String! = exam["ScoreDetail"]["Extension"]["Extension"]["Score"].element?.text
                        let assignmentScore:String! = exam["ScoreDetail"]["Extension"]["Extension"]["AssignmentScore"].element?.text
                        
                        var avg = Double.NaN
                        
                        if score != nil && assignmentScore != nil{
                            avg = score.doubleValue * (percentage.doubleValue / 100) + assignmentScore.doubleValue * ((100-percentage.doubleValue) / 100)
                        }
                        else if score != nil{
                            avg = score.doubleValue
                        }
                        else if assignmentScore != nil{
                            avg = assignmentScore.doubleValue
                        }
                        
                        if !avg.isNaN{
                            
                            self._data.append(ExamScore(SchoolYear: sy, Semester: sm, Subject: subject, Exam: examName, Domain: domain, Score: score, AssignmentScore: assignmentScore, Credit: credit, State: "fair", Avg: avg.toString()))
                            
                            //每個學年度學期應該呈現的考試
                            if !contains(self._examDic["\(sy)#\(sm)"]!, examName){
                                self._examDic["\(sy)#\(sm)"]?.append(examName)
                            }
                        }
                    }
                }
            }
            
            self.SetSYSMBtn()
        }
    }
    
    //高中成績
    func GetSHData(){
        
        Global.CurrentChild.Con.SendRequest("evaluateScoreSH.GetExamScore", body: "<Request><Condition><StudentID>\(Global.CurrentChild.ID)</StudentID></Condition></Request>") { (response) -> () in
            
            self.studentBtn.setTitle(Global.CurrentChild.Name, forState: UIControlState.Normal)
            
            //println(NSString(data: response, encoding: NSUTF8StringEncoding))
            
            var xml = SWXMLHash.parse(response)
            
            for sems in xml["Envelope"]["Body"]["ExamScoreList"]["Seme"] {
                
                let sy:String! = sems.element?.attributes["SchoolYear"]
                let sm:String! = sems.element?.attributes["Semester"]
                
                self._sysm.append(SYSM(SchoolYear: sy, Semester: sm, Content: "\(sy)學年度第\(sm)學期"))
                
                if self._examDic["\(sy)#\(sm)"] == nil{
                    self._examDic["\(sy)#\(sm)"] = [String]()
                }
                
                for course in sems["Course"]{
                    
                    let subject:String! = course.element?.attributes["Subject"]
                    var lastScore:Double = Double.NaN
                    
                    for exam in course["Exam"]{
                        let examName:String! = exam.element?.attributes["ExamName"]
                        let score:String! = exam["ScoreDetail"].element?.attributes["Score"]
                        let scoreValue = score.doubleValue
                        
                        if lastScore == Double.NaN{
                            self._data.append(ExamScore(SchoolYear: sy, Semester: sm, Subject: subject, Exam: examName, Domain: "", Score: score, AssignmentScore: "", Credit: "", State: "fair", Avg: ""))
                        }
                        else if scoreValue > lastScore{
                            self._data.append(ExamScore(SchoolYear: sy, Semester: sm, Subject: subject, Exam: examName, Domain: "", Score: score, AssignmentScore: "", Credit: "", State: "progress", Avg: ""))
                        }
                        else if scoreValue < lastScore{
                            self._data.append(ExamScore(SchoolYear: sy, Semester: sm, Subject: subject, Exam: examName, Domain: "", Score: score, AssignmentScore: "", Credit: "", State: "regress", Avg: ""))
                        }
                        else{
                            self._data.append(ExamScore(SchoolYear: sy, Semester: sm, Subject: subject, Exam: examName, Domain: "", Score: score, AssignmentScore: "", Credit: "", State: "fair", Avg: ""))
                        }
                        
                        //記錄上次成績作比較
                        lastScore = scoreValue
                        
                        //每個學年度學期應該呈現的考試
                        if !contains(self._examDic["\(sy)#\(sm)"]!, examName){
                            self._examDic["\(sy)#\(sm)"]?.append(examName)
                        }
                    }
                }
            }
            
            self.SetSYSMBtn()
        }
    }
    
    func SetSYSMBtn(){
        
        self.sysmActionSheet = UIActionSheet(title: "請選擇學年度學期", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil)
        
        self._sysm = self._sysm.reverse()
        
        for sysm in self._sysm{
            self.sysmActionSheet.addButtonWithTitle(sysm.Content)
        }
        
        if self._sysm.count > 0{
            self.sysmBtn.setTitle(self._sysm[0].Content, forState: UIControlState.Normal)
            self.actionSheet(self.sysmActionSheet,clickedButtonAtIndex: 1)
        }
        else{
            self.sysmBtn.setTitle("查無學期成績資料", forState: UIControlState.Normal)
            self.examActionSheet = UIActionSheet(title: "請選擇試別", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil)
            self.examBtn.setTitle("查無試別", forState: UIControlState.Normal)
        }
        
        Global.Loading.hideActivityIndicator(self.view)
    }
    
    // Called when a button is clicked. The view will be automatically dismissed after this call returns
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int){
        
        if actionSheet == self.actionSheet{
            
            if buttonIndex == 0 {
                return
            }
            
            Global.CurrentChild = Global.ChildList[buttonIndex - 1]
            ClearTable()
            PrepareToGetData()
            
        }
        else if actionSheet == self.sysmActionSheet{
            
            if buttonIndex == 0{
                return
            }
            
            ClearTable()
            
            let sysm = self._sysm[buttonIndex-1]
            let key = "\(sysm.SchoolYear)#\(sysm.Semester)"
            
            sysmBtn.setTitle(sysm.Content, forState: UIControlState.Normal)
            _currentSY = sysm.SchoolYear
            _currentSM = sysm.Semester
            
            self.examActionSheet = UIActionSheet(title: "請選擇試別", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil)
            
            if let exams = self._examDic[key]{
                if exams.count > 0{
                    
                    for exam in exams{
                        self.examActionSheet.addButtonWithTitle(exam)
                    }
                    
                    self.examBtn.setTitle(exams[0], forState: UIControlState.Normal)
                    self.actionSheet(self.examActionSheet,clickedButtonAtIndex: 1)
                    
                }
                else{
                    self.examBtn.setTitle("查無試別", forState: UIControlState.Normal)
                }
            }
        }
        else{
            
            if buttonIndex == 0{
                return
            }
            
            ClearTable()
            
            let currentExam = examActionSheet.buttonTitleAtIndex(buttonIndex)
            examBtn.setTitle(currentExam, forState: UIControlState.Normal)
            
            //先整理篩選後的考試資料
            var tmpData = [ExamScore]()
            
            for data in _data{
                if data.SchoolYear == _currentSY && data.Semester == _currentSM && data.Exam == currentExam{
                    tmpData.append(data)
                }
            }
            
            if self._isJH == true{
                
                //國中先作domain分類
                var domainList = [String]()
                
                for data in tmpData{
                    if !contains(domainList, data.Domain){
                        domainList.append(data.Domain)
                    }
                }
                
                //按domain挑出對應科目
                for domain in domainList{
                    
                    var count:Double = Double(0)
                    var sum:Double = Double(0)
                    var appends = [ExamScore]()
                    
                    //符合的科目加入陣列並做加權計算
                    for tmp in tmpData{
                        if tmp.Domain == domain{
                            count += tmp.Credit.doubleValue
                            sum += tmp.Avg.doubleValue * tmp.Credit.doubleValue
                            appends.append(tmp)
                        }
                    }
                    
                    let avg = sum / count
                    
                    //先插入一條domain列表
                    self._displayData.append(ExamScore(SchoolYear: _currentSY, Semester: _currentSM, Subject: "", Exam: currentExam, Domain: domain, Score: "", AssignmentScore: "", Credit: "", State: "title", Avg: avg.toString()))
                    
                    //接著掛上對應科目
                    for item in appends{
                        self._displayData.append(item)
                    }
                }
                
                
            }
            else{
                //高中直接呈現資料
                self._displayData = tmpData
            }
            
            tableView.reloadData()
        }
    }
    
    
    
    func CheckDSNS(dsns:String) {
        
        self._isJH = false
        self._isHS = false
        var response:AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        var error: NSErrorPointer = nil
        
        var request = NSMutableURLRequest()
        
        //request.URL = NSURL.URLWithString(self.getAuthUrl(type))
        var url = "https://spreadsheets.google.com/feeds/list/1ZLFzPPd6y3psjDGl-z1RmQTxAtCOCVQxFOE4PB54tD4/1/public/values?&q=\(dsns)"
        request.URL = NSURL(string: url)
        request.timeoutInterval = 3
        
        
        // Sending Synchronous request using NSURLConnection
        
        var tokenData = NSURLConnection.sendSynchronousRequest(request,returningResponse: response, error: error)
        
        if error != nil
        {
            // You can handle error response here
            println("Get Data error: \(error)")
        }
        else
        {
            if let data = tokenData as NSData?{
                //println(NSString(data: data, encoding: NSUTF8StringEncoding))
                var xml = SWXMLHash.parse(data)
                
                for elem in xml["feed"]["entry"]{
                    
                    if let type = elem["gsx:type"].element?.text{
                        //println("type:\(type)")
                        if type == "jh"{
                            self._isJH = true
                        }
                    }
                    
                    if let location = elem["gsx:location"].element?.text{
                        //println("location:\(location)")
                        if location == "hs"{
                            self._isHS = true
                        }
                    }
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return _displayData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        if self._isJH == true{
            
            if _displayData[indexPath.row].State == "title"{
                var cell = tableView.dequeueReusableCellWithIdentifier("examScoreTitleCell") as! ExamScoreTitleCell
                cell.domain.text = _displayData[indexPath.row].Domain
                cell.score.text = _displayData[indexPath.row].Avg
                
                return cell
            }
            
            var cell = tableView.dequeueReusableCellWithIdentifier("jhExamScoreCell") as! JHExamScoreCell
            
            cell.subject.text = _displayData[indexPath.row].Subject
            cell.credit.text = _displayData[indexPath.row].Credit
            cell.score.text = _displayData[indexPath.row].Score
            cell.assignmentScore.text = _displayData[indexPath.row].AssignmentScore
            cell.avg.text = _displayData[indexPath.row].Avg
            
            //高雄新竹顯示隱藏
            cell.titleA.hidden = true
            cell.titleB.hidden = true
            cell.score.hidden = true
            cell.assignmentScore.hidden = true
            if self._isHS == true{
                cell.titleA.hidden = false
                cell.titleB.hidden = false
                cell.score.hidden = false
                cell.assignmentScore.hidden = false
            }
            
            return cell
        }
        else{
            
            var cell = tableView.dequeueReusableCellWithIdentifier("shExamScoreCell") as! SHExamScoreCell
            
            cell.subject.text = _displayData[indexPath.row].Subject
            cell.score.text = _displayData[indexPath.row].Score
            
            cell.score.textColor = UIColor.blackColor()
            if _displayData[indexPath.row].Score.doubleValue < 60{
                cell.score.textColor = UIColor.redColor()
            }
            
            if _displayData[indexPath.row].State == "progress"{
                cell.state.image = _upArrow
            }
            else if _displayData[indexPath.row].State == "regress"{
                cell.state.image = _downArrow
            }
            else{
                cell.state.image = _emptyArrow
            }
            
            return cell
        }
    }
    
    func ClearTable(){
        _displayData.removeAll(keepCapacity: false)
        tableView.reloadData()
    }
}