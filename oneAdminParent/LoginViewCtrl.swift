//
//  FirstViewController.swift
//  oneAdminParent
//
//  Created by Cloud on 11/14/14.
//  Copyright (c) 2014 ischool. All rights reserved.
//

import UIKit

class LoginViewCtrl: UIViewController, UITextFieldDelegate,FBLoginViewDelegate {
    
    struct Login {
        static var token: dispatch_once_t = 0
    }
    
    var _con:Connector!
    var fbToken:String!
    var _screenHeight:CGFloat!
    var _orginframe:CGRect!
    
    //@IBOutlet weak var content: UIView!
    
    @IBOutlet weak var fbLoginView: FBLoginView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        status.hidden = true
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        _screenHeight = screenSize.height
        
        //Global.AdjustView(content)
        //_orginframe = CGRectMake(self.content.frame.origin.x, self.content.frame.origin.y, self.view.bounds.width, self.view.bounds.height)
        
        button.layer.cornerRadius = 5
        
        //self.frameView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
        
        // Keyboard stuff.
//        var center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
//        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
//        center.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        fbLoginView.delegate = self
        fbLoginView.readPermissions = ["public_profile","email","user_friends"]
        
        Global.LVC = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //not allow change to orientation
    override func shouldAutorotate() -> Bool{
        return false
    }
    
    //force to use Portrait orientation
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientationMask.Portrait.rawValue.hashValue | UIInterfaceOrientationMask.PortraitUpsideDown.rawValue.hashValue
    }
    
    // called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(textField: UITextField!) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
    
    // called when screen touch
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent){
        self.view.endEditing(true)
    }
    
//    func keyboardWillShow(notification: NSNotification) {
//        
//        if self._screenHeight <= 568{
//            var info:NSDictionary = notification.userInfo!
//            var keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as NSValue).CGRectValue()
//            
//            var keyboardHeight:CGFloat = keyboardSize.height
//            
//            //var animationDuration:CGFloat = info[UIKeyboardAnimationDurationUserInfoKey] as NSNumber
//            var animationDuration:CGFloat = info[UIKeyboardAnimationDurationUserInfoKey] as CGFloat
//            
//            UIView.animateWithDuration(0.25, delay: 0.25, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
//                self.content.frame = CGRectMake(self.content.frame.origin.x, (self.content.frame.origin.y - keyboardHeight), self.view.bounds.width, self.view.bounds.height)
//                }, completion: nil)
//        }
//    }
    
//    func keyboardWillHide(notification: NSNotification) {
//        
//        if self._screenHeight <= 568{
//            var info:NSDictionary = notification.userInfo!
//            var keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as NSValue).CGRectValue()
//            
//            var keyboardHeight:CGFloat = keyboardSize.height
//            
//            //var animationDuration:CGFloat = info[UIKeyboardAnimationDurationUserInfoKey] as NSNumber
//            var animationDuration:CGFloat = info[UIKeyboardAnimationDurationUserInfoKey] as CGFloat
//            
//            UIView.animateWithDuration(0.25, delay: 0.25, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
//                //self.content.frame = CGRectMake(self.content.frame.origin.x, (self.content.frame.origin.y + keyboardHeight), self.view.bounds.width, self.view.bounds.height)
//                self.content.frame = self._orginframe
//                }, completion: nil)
//        }
//    }
    
    //When FB login
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        self.view.endEditing(true)
        Global.Loading.showActivityIndicator(self.view)
        //println("fb log in")
    }
    
    //after FB login
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        
        //可能會觸發兩次,所以做判斷確保是必要的執行
        if let token = FBSession.activeSession().accessTokenData.accessToken{
            if fbToken != token{
                fbToken = token
                LoginWithFB()
            }
        }
        
        //fbToken = FBSession.activeSession().accessTokenData.accessToken
        //LoginWithFB()
        
        //            println("user name: \(user.name)")
        //            println("token: \(fbToken)")
        //            println(user.objectForKey("email"))
    }
    
    //after FB logout
    func loginViewShowingLoggedOutUser(loginView: FBLoginView!) {
        //println("fb log out")
    }
    
    //FB login error
    func loginView(loginView: FBLoginView!, handleError error: NSError!) {
        //println("fb login error")
    }
    
    @IBAction func loginBtn(sender: AnyObject) {
        self.view.endEditing(true)
        Global.Loading.showActivityIndicator(self.view)
        LoginWithGreening()
    }
    
    func LoginWithGreening(){
        //Global.Loading.showActivityIndicator(self.view)
        //self.status.text = "登入驗證"
        _con = Connector(authUrl: "https://auth.ischool.com.tw/oauth/token.php", accessPoint: "https://auth.ischool.com.tw:8443/dsa/greening", contract: "user")
        _con.ClientID = "5e89bdfbf971974e3b53312384c0013a"
        _con.ClientSecret = "855b8e05afadc32a7a2ecbf0b09011422e5e84227feb5449b1ad60078771f979"
        _con.UserName = self.userName.text
        _con.Password = self.password.text
//                _con.UserName = "imcloudwu@gmail.com"
//                _con.Password = "1234"
        
        if _con.IsValidated("greening"){
            Global.connector = _con
            GetChildList(nil)
        }
        else{
            self.status.text = "登入失敗"
            let alert = UIAlertView()
            alert.title = "登入失敗"
            alert.message = "帳號密碼可能錯誤"
            alert.addButtonWithTitle("OK")
            alert.show()
            Global.Loading.hideActivityIndicator(self.view)
        }
        
    }
    
    func LoginWithFB(){
        //Global.Loading.showActivityIndicator(self.view)
        //self.status.text = "登入驗證"
        //println("fb login")
        _con = Connector(authUrl: "https://auth.ischool.com.tw/oauth/token.php", accessPoint: "https://auth.ischool.com.tw:8443/dsa/greening", contract: "user")
        _con.ClientID = "5e89bdfbf971974e3b53312384c0013a"
        _con.ClientSecret = "855b8e05afadc32a7a2ecbf0b09011422e5e84227feb5449b1ad60078771f979"
        _con.FBToken = fbToken
        
        if _con.IsValidated("FB"){
            Global.connector = _con
            GetChildList(nil)
        }
        else{
            self.status.text = "登入失敗"
            let alert = UIAlertView()
            alert.title = "登入失敗"
            alert.message = "帳號密碼可能錯誤"
            alert.addButtonWithTitle("OK")
            alert.show()
            Global.Loading.hideActivityIndicator(self.view)
        }
    }
    
    func GetChildList(sender:UIViewController!){
        
        //println("get child")
        if sender != nil{
            Global.Loading.showActivityIndicator(sender.view)
        }
        
        Login.token = 0
        
        Global.ChildList.removeAll(keepCapacity: false)
        
        var dsnsList = [String]()
        
        Global.connector.SendRequest("GetApplicationListRef", body: "<Request><Type>dynpkg</Type></Request>") { (response) -> () in
            self.status.text = "取得DSNS"
            //println(NSString(data: response, encoding: NSUTF8StringEncoding))
            var xml = SWXMLHash.parse(response)
            
            //User
            for elem in xml["Envelope"]["Body"]["Response"]["User"]["App"]{
                if let dsns = elem.element?.attributes["AccessPoint"]{
                    if !contains(dsnsList,dsns){
                        dsnsList.append(dsns)
                    }
                }
            }
            
            //Domain
            for elem in xml["Envelope"]["Body"]["Response"]["Domain"]["App"]{
                if let dsns = elem.element?.attributes["AccessPoint"]{
                    if !contains(dsnsList,dsns){
                        dsnsList.append(dsns)
                    }
                }
            }
            
            //println(dsnsList)
            if dsnsList.count == 0{
                self.MoveToAddChildPage()
            }
            
            //Prepare for check
            var check = Dictionary<String,Bool>()
            for dsns in dsnsList{
                check[dsns] = false
            }
            
            //取得DSNS的URL清單
            Global.DSNS = dsnsList
            for dsns in dsnsList{
                HttpClient.Get(GetDoorWayURL(dsns)){data in
                    self.status.text = "取得主機位置"
                    var xml = SWXMLHash.parse(data)
                    //println(NSString(data: data, encoding: NSUTF8StringEncoding))
                    for elem in xml["Envelope"]["Body"]["DoorwayURL"]{
                        if let DoorwayURL = elem.element?.text{
                            //println(DoorwayURL)
                            
                            var con = self._con.Clone()
                            con.AccessPoint = DoorwayURL
                            con.Contract = "ischool.parent.app"
                            //con.GetSessionID()
                            con.SessionID = nil
                            
                            con.SendRequest("main.GetMyChildren", body: ""){data in
                                //println(NSString(data: data, encoding: NSUTF8StringEncoding))
                                //println("Change \(dsns) to true")
                                check[dsns] = true
                                self.status.text = "取得主機\(dsns)小孩清單"
                                var xml = SWXMLHash.parse(data)
                                
                                for student in xml["Envelope"]["Body"]["Student"]{
                                    if let id = student["StudentId"].element?.text{
                                        if let name = student["StudentName"].element?.text{
                                            Global.ChildList.append(Child(DSNS: dsns, ID: id, Name: name, Con: con))

//                                            Global.ChildList.append(Child(AccessPoint: con.AccessPoint, ID: id, Name: name, Con: con))
                                            //println(id)
                                        }
                                    }
                                }
                                
                                //                                if let envelope = xml["Envelope"].element{
                                //                                    if let body = xml["Envelope"]["Body"].element{
                                //                                        if let student = xml["Envelope"]["Body"]["Student"].element{
                                //                                            for elem in xml["Envelope"]["Body"]["Student"] {
                                //                                                if let id = elem["StudentId"].element?.text{
                                //                                                    if let name = elem["StudentName"].element?.text{
                                //                                                        Global.ChildList.append(Child(AccessPoint: con.AccessPoint, ID: id, Name: name, Con: con))
                                //                                                        //println(id)
                                //                                                    }
                                //                                                }
                                //                                            }
                                //                                        }
                                //                                    }
                                //                                }
                                
                                self.MoveToMainPage(check,sender: sender)
                            }
                        }
                    }
                }
            }
            //            var nextView = self.storyboard?.instantiateViewControllerWithIdentifier("Main") as UIViewController
            //            self.presentViewController(nextView, animated: true, completion: nil)
        }
        
    }
    
    func MoveToMainPage(check:Dictionary<String,Bool>,sender:UIViewController!){
        var bool = true
        for value in check{
            if !value.1 {
                bool = false
                break
            }
        }
        
        if bool{
            if Global.ChildList.count > 0{
                dispatch_once(&Login.token) {
                    //Global.Selector = PrompView.GetInstance()
                    Global.Selector = SelectStudentView.GetInstance()
                    var nextView = self.storyboard?.instantiateViewControllerWithIdentifier("Main") as UIViewController
                    
                    if sender == nil{
                        self.presentViewController(nextView, animated: true, completion: nil)
                        //println("MoveToMainPage from login")
                    }
                    else{
                        sender.presentViewController(nextView, animated: true, completion:nil)
                        //println("MoveToMainPage from addPage")
                    }
                    
                    if sender != nil{
                        Global.Loading.hideActivityIndicator(sender.view)
                    }
                    else{
                        Global.Loading.hideActivityIndicator(self.view)
                    }
                }
            }
            else{
                MoveToAddChildPage()
            }
        }
    }
    
    func MoveToAddChildPage(){
        var nextView = self.storyboard?.instantiateViewControllerWithIdentifier("myChild") as UIViewController
        self.presentViewController(nextView, animated: true, completion: nil)
        
        Global.Loading.hideActivityIndicator(self.view)
    }
}

