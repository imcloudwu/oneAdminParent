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
    
    @IBOutlet weak var content: UIView!
    
    @IBOutlet weak var fbLoginView: FBLoginView!
    @IBOutlet weak var status: UILabel!
    
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func ggg(sender: AnyObject) {
        var nextView = self.storyboard?.instantiateViewControllerWithIdentifier("Main") as UIViewController
        
        
        self.presentViewController(nextView, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Global.AdjustView(content)
        
        button.layer.cornerRadius = 5
        
        //self.frameView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
        
        // Keyboard stuff.
        var center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        fbLoginView.delegate = self
        fbLoginView.readPermissions = ["public_profile","email","user_friends"]
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
        return UIInterfaceOrientationMask.Portrait.toRaw().hashValue | UIInterfaceOrientationMask.PortraitUpsideDown.toRaw().hashValue
    }
    
    //    override func viewDidAppear(animated: Bool) {
    //
    //        let screenSize: CGRect = UIScreen.mainScreen().bounds
    //        //let screenWidth = screenSize.width;
    //        let screenHeight = screenSize.height;
    //        //let screenWidth = screenSize.width * .75;
    //
    //        //println(screenHeight)
    //        if screenHeight >= 736{
    //            content.frame.offset(dx: 19, dy: 0)
    //        }
    //        else if screenHeight <= 568{
    //            content.frame.offset(dx: -28, dy: 0)
    //        }
    //    }
    
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
    
    func keyboardWillShow(notification: NSNotification) {
        var info:NSDictionary = notification.userInfo!
        var keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as NSValue).CGRectValue()
        
        var keyboardHeight:CGFloat = keyboardSize.height
        
        var animationDuration:CGFloat = info[UIKeyboardAnimationDurationUserInfoKey] as NSNumber
        
        UIView.animateWithDuration(0.25, delay: 0.25, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.content.frame = CGRectMake(self.content.frame.origin.x, (self.content.frame.origin.y - keyboardHeight), self.view.bounds.width, self.view.bounds.height)
            }, completion: nil)
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        var info:NSDictionary = notification.userInfo!
        var keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as NSValue).CGRectValue()
        
        var keyboardHeight:CGFloat = keyboardSize.height
        
        var animationDuration:CGFloat = info[UIKeyboardAnimationDurationUserInfoKey] as NSNumber
        
        UIView.animateWithDuration(0.25, delay: 0.25, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.content.frame = CGRectMake(self.content.frame.origin.x, (self.content.frame.origin.y + keyboardHeight), self.view.bounds.width, self.view.bounds.height)
            }, completion: nil)
        
    }
    
    //When FB login
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        println("fb log in")
    }
    
    //after FB login
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        
        if fbToken == nil{
            fbToken = FBSession.activeSession().accessTokenData.accessToken
            LoginWithFB()
        }
        //println("user name: \(user.name)")
        //println("token: \(fbToken)")
        //println(user.objectForKey("email"))
    }
    
    //after FB logout
    func loginViewShowingLoggedOutUser(loginView: FBLoginView!) {
        println("fb log out")
    }
    
    //FB login error
    func loginView(loginView: FBLoginView!, handleError error: NSError!) {
        println("fb login error")
    }
    
    func LoginWithFB(){
        
        self.status.text = "登入驗證"
        _con = Connector(authUrl: "https://auth.ischool.com.tw/oauth/token.php", accessPoint: "https://auth.ischool.com.tw:8443/dsa/greening", contract: "user")
        _con.ClientID = "5e89bdfbf971974e3b53312384c0013a"
        _con.ClientSecret = "855b8e05afadc32a7a2ecbf0b09011422e5e84227feb5449b1ad60078771f979"
        _con.FBToken = fbToken
        
        if _con.IsValidated(){
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
        }
    }
    
    func GetChildList(sender:UIViewController!){
        
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
            for dsns in dsnsList{
                HttpClient.Get(GetDoorWayURL(dsns)){data in
                    self.status.text = "取得主機位置"
                    var xml = SWXMLHash.parse(data)
                    for elem in xml["Envelope"]["Body"]["DoorwayURL"]{
                        if let DoorwayURL = elem.element?.text{
                            //println(DoorwayURL)
                            
                            var con = self._con.Clone()
                            con.AccessPoint = DoorwayURL
                            con.Contract = "ischool.parent.app"
                            con.GetSessionID()
                            
                            con.SendRequest("main.GetMyChildren", body: ""){data in
                                //println(NSString(data: data, encoding: NSUTF8StringEncoding))
                                //println("Change \(dsns) to true")
                                check[dsns] = true
                                self.status.text = "取得主機\(dsns)小孩清單"
                                var xml = SWXMLHash.parse(data)
                                for elem in xml["Envelope"]["Body"]["Student"] {
                                    if let id = elem["StudentId"].element?.text{
                                        if let name = elem["StudentName"].element?.text{
                                            Global.ChildList.append(Child(AccessPoint: con.AccessPoint, ID: id, Name: name, Con: con))
                                            //println(id)
                                        }
                                    }
                                }
                                
                                self.MoveToMainPage(check,sender: sender)
                            }
                        }
                    }
                }
            }
            
            Global.DSNS = dsnsList
            
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
                        println("MoveToMainPage from login")
                    }
                    else{
                        sender.presentViewController(nextView, animated: true, completion:nil)
                        println("MoveToMainPage from addPage")
                    }
                }
            }
            else{
                MoveToAddChildPage()
            }
        }
    }
    
    func MoveToAddChildPage(){
        //var nextView = self.storyboard?.instantiateViewControllerWithIdentifier("addChild") as UIViewController
        //self.presentViewController(nextView, animated: true, completion: nil)
    }
}
