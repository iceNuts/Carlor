//
//  Activate.swift
//  Carlor
//
//  Created by Li Zeng on 1/9/15.
//  Copyright (c) 2015 CarlorClub. All rights reserved.
//

import Foundation

import Alamofire

// Router

enum RestActivate: URLRequestConvertible {
    
    case ActivateUser([String: String])
    case ResendCode([String: String])
    case GetActivateStatus(String)
    
    var method: Alamofire.Method {
        switch self {
        case .ActivateUser:
            return .POST
        case .ResendCode:
            return .PUT
        case .GetActivateStatus:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .ActivateUser:
            return "/api/v1/user/activate"
        case .ResendCode:
            return "/api/v1/user/activate/resend"
        case .GetActivateStatus(let userid):
            return "/api/v1/user/activated/\(userid)"
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
        case .ActivateUser(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .ResendCode(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
}


// Function Wrapper

struct HttpActivate {
    
    // create a new user
    internal static func activateUser(#userid: String, code: String) -> Void {
        Alamofire.request(RestActivate.ActivateUser([
            "userid"    : userid,
            "code"      : code,
            ]))
            .validate()
            .validate(contentType: ["application/json"])
            .responseJSON() { (req, res, data, err) -> Void in
                let json = JSON(data!)
                // proceed to activate user
                if err == nil {
                    println(json)
                    RestConfig.storeAuthToken(json["token"].stringValue)
                }
                // handle exception
                else {
                    let reason = json["reason"].stringValue
                    println(reason)
                }
        }
        // return void
    }
    
    // resend activate email
    internal static func resendEmail(#userid: String) -> Void {
        Alamofire.request(RestActivate.ResendCode([
            "userid"    : userid
            ]))
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
    
    // get activate status
    internal static func getActivateStatus(#userid: String) -> Void {
        Alamofire.request(RestActivate.GetActivateStatus(userid))
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









