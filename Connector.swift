//
//  Connector.swift
//  App
//
//  Created by Cloud on 10/8/14.
//  Copyright (c) 2014 Cloud. All rights reserved.
//

import Foundation

public class Connector{
    
    var AccessToken:String!
    var RefreshToken:String!
    var SessionID:String!
    var ClientID:String!
    var ClientSecret:String!
    var UserName:String!
    var Password:String!
    var AccessPoint:String!
    var Contract:String!
    var FBToken:String!
    private var AuthUrl:String!
    
    var tmpCode = ""
    
    init(authUrl:String,accessPoint:String,contract:String){
        AuthUrl = authUrl
        AccessPoint = accessPoint
        Contract = contract
    }
    
    public func Clone() -> Connector{
        var con = Connector(authUrl: AuthUrl,accessPoint: AccessPoint,contract: Contract)
        con.AccessToken = AccessToken
        con.RefreshToken = RefreshToken
        con.SessionID = SessionID
        con.ClientID = ClientID
        con.ClientSecret = ClientSecret
        con.UserName = UserName
        con.Password = Password
        con.AccessPoint = AccessPoint
        con.Contract = Contract
        return con
    }
    
    private func getAuthUrl() -> String {
        //return "\(AuthUrl)?grant_type=password&client_id=\(ClientID)&client_secret=\(ClientSecret)&username=\(UserName)&password=\(Password)"
        
        return "https://auth.ischool.com.tw/c/servicem/fbtoken.php?fbtoken=\(FBToken)&client_id=\(ClientID)&client_secret=\(ClientSecret)"
    }
    
    func SendRequest(service:String,body:String,function:(response:NSData) -> ()){
        
        if SessionID == nil {
            GetSessionID()
        }
        
        var body = "<Envelope><Header><TargetContract>\(self.Contract)</TargetContract><TargetService>\(service)</TargetService><SecurityToken Type='Session'><SessionID>\(self.SessionID)</SessionID></SecurityToken></Header><Body>\(body)</Body></Envelope>"
        
        HttpClient.POST(self.AccessPoint, body: body, callback: { data in
            function(response: data)
        })
    }
    
    func SendRequestTest(service:String,body:String,function:(response:NSData) -> ()){
        
        //<TargetContract>\(self.Contract)</TargetContract>
        var body = "<Envelope><Header><SecurityToken Type='Public'/><TargetService>\(service)</TargetService></Header><Body>\(body)</Body></Envelope>"
        
        HttpClient.POST(self.AccessPoint, body: body, callback: { data in
            function(response: data)
        })
    }
    
    func IsValidated() -> Bool {
        GetAccessToken()
        GetSessionID()
        
        if self.SessionID == nil{
            return false
        }
        else{
            return true
        }
    }
    
    public func GetAccessToken(){
        var response:AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        var error: NSErrorPointer = nil
        
        var request = NSMutableURLRequest()
        
        request.URL = NSURL.URLWithString(self.getAuthUrl())
        // Sending Synchronous request using NSURLConnection
        
        var tokenData = NSURLConnection.sendSynchronousRequest(request,returningResponse: response, error: error) as NSData!
        //println(AccessToken)
        
        if error != nil
        {
            // You can handle error response here
            println("Get AccessToken error: \(error)")
        }
        else
        {
            //Converting data to String
            var jsonResult = NSJSONSerialization.JSONObjectWithData(tokenData, options: nil, error: nil) as NSDictionary
            //println(NSString(data: tokenData, encoding: NSUTF8StringEncoding))
            
            var wrapping_accessToken = jsonResult["access_token"] as String?
            var wrapping_refreashToken = jsonResult["refresh_token"] as String?
            
            if let refreashToken = wrapping_refreashToken{
                self.RefreshToken = refreashToken
                //println(self.RefreshToken)
            }
            
            if let accessToken = wrapping_accessToken {
                self.AccessToken = accessToken
            }
        }
    }
    
    public func GetSessionID() {
        var response:AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        var error: NSErrorPointer = nil
        
        var request = NSMutableURLRequest()
        
        var body = "<Envelope><Header><TargetContract>\(self.Contract)</TargetContract><TargetService>DS.Base.Connect</TargetService><SecurityToken Type='PassportAccessToken'><AccessToken>\(self.AccessToken)</AccessToken></SecurityToken></Header><Body><RequestSessionID/></Body></Envelope>"
        
        request.URL = NSURL.URLWithString(self.AccessPoint)
        request.HTTPMethod = "POST"
        request.HTTPBody = body.dataUsingEncoding( NSUTF8StringEncoding, allowLossyConversion: true)
        
        var sessionData = NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: error) as NSData!
        
        if error != nil{
            // You can handle error response here
            println("Get SessionID error: \(error)")
        }
        else{
            println(NSString(data: sessionData, encoding: NSUTF8StringEncoding))
            var xml = SWXMLHash.parse(sessionData)
            var wrapping_sessionid = xml["Envelope"]["Body"]["SessionID"].element?.text
            
            if let sessionid = wrapping_sessionid{
                self.SessionID = sessionid
                //println("sessionid: \(sessionid)")
            }
        }
        
    }
}
