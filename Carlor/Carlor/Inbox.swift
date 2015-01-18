//
//  Inbox.swift
//  Carlor
//
//  Created by Li Zeng on 1/17/15.
//  Copyright (c) 2015 CarlorClub. All rights reserved.
//

import Foundation
import Alamofire

// Router

enum RestInbox: URLRequestConvertible {
    
    case CreateMessage([String: String])
    case GetMessage()
    
    var method: Alamofire.Method {
        switch self {
        case .CreateMessage:
            return .POST
        case .GetMessage:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .CreateMessage:
            return "/api/v1/inbox/create"
        case .GetMessage:
            return "/api/v1/inbox/get"
        }
    }
    
    var URLRequest: NSURLRequest {
        let URL: NSURL = NSURL(string: RestConfig.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        var authToken: String? = RestConfig.readAuthToken()
        var userid: String? = RestConfig.readUserid()
        
        if authToken != nil && userid != nil{
            mutableURLRequest.setValue("Basic "+authToken!+":"+userid!, forHTTPHeaderField: "Authorization")
        }
        
        switch self {
        case .CreateMessage(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
}

// Function Wrapper

struct HttpInbox {
    
    // create a new message to someone
    internal static func createMessage(
        #target: String,
        payload: String
        ) -> Void {
            Alamofire.request(RestInbox.CreateMessage([
                "target"        : target,
                "payload"       : payload
                ]))
                .validate()
                .validate(contentType: ["application/json"])
                .responseJSON() { (req, res, data, err) -> Void in
                    let json = JSON(data!)
                    // proceed to create user
                    if err == nil {
                        println(json)
                    }
                    // handle exception
                    else {
                        let reason = json["reason"].stringValue
                        println(reason)
                    }
            }
            // return void
    }
    
    // get messages
    internal static func getMessage() -> Void {
        Alamofire.request(RestInbox.GetMessage())
            .validate()
            .validate(contentType: ["application/json"])
            .responseJSON() { (req, res, data, err) -> Void in
                let json = JSON(data!)
                // proceed
                if err == nil {
                    println(json)
                }
                // handle exception
                else {
                    let reason = json["reason"].stringValue
                    println(reason)
                }
        }
        // return void
    }
    
}
