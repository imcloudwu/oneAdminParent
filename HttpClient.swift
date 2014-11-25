//
//  Http.swift
//  App
//
//  Created by Cloud on 10/8/14.
//  Copyright (c) 2014 Cloud. All rights reserved.
//

import Foundation

public class HttpClient{
    
    class func Get(url:String,callback:(data:NSData) -> ()){
        
        var req = NSURLRequest(URL: NSURL(string: url))
        var conn = NSURLConnection(request: req, delegate: HttpRequest(callback), startImmediately: true)
    }
    
    class func POST(url:String,body:String,callback:(data:NSData) -> ()){
        
        var req = NSMutableURLRequest()
        req.URL = NSURL(string:url)
        println(url)
        req.HTTPMethod = "POST"
        req.HTTPBody = body.dataUsingEncoding( NSUTF8StringEncoding, allowLossyConversion: true)
        var conn = NSURLConnection(request: req, delegate: HttpRequest(callback), startImmediately: true)
    }
    
    class HttpRequest:NSObject{
        
        private var callback:(data:NSData) -> ()
        
        init(callback:(data:NSData) -> ()){
            self.callback = callback
        }
        
        func connection(connection: NSURLConnection, didReceiveData data: NSData){
            //var resopnse = NSString(data: data, encoding: NSUTF8StringEncoding)
            self.callback(data:data)
        }
    }
}

//    class func SendSyncRequest(url:String) -> NSData? {
//        var response:AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
//        var error: NSErrorPointer = nil
//
//        var request = NSMutableURLRequest()
//        request.URL = NSURL.URLWithString(url)
//
//        var data = NSURLConnection.sendSynchronousRequest(request,returningResponse: response, error: error)
//        return data
//    }
//
//    class func SendSyncRequest(url:String,body:String) -> NSData? {
//        var response:AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
//        var error: NSErrorPointer = nil
//
//        var request = NSMutableURLRequest()
//        request.HTTPMethod = "POST"
//        request.URL = NSURL.URLWithString(url)
//        request.HTTPBody = body.dataUsingEncoding( NSUTF8StringEncoding, allowLossyConversion: true)
//
//        var data = NSURLConnection.sendSynchronousRequest(request,returningResponse: response, error: error)
//        return data
//    }