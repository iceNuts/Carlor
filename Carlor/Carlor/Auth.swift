//
//  Auth.swift
//  Carlor
//
//  Created by Li Zeng on 1/9/15.
//  Copyright (c) 2015 CarlorClub. All rights reserved.
//

import Foundation

import Alamofire


// Router

enum RestAuth: URLRequestConvertible {
    
    case Login([String: String])
    case Logout([String: String])
    
    var method: Alamofire.Method {
        switch self {
        case .Login:
            return .POST
        case .Logout:
            return .DELETE
        }
    }
    
    var path: String {
        switch self {
        case .Login:
            return "/api/v1/auth/login"
        case .Logout:
            return "/api/v1/auth/logout"
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
        case .Login(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .Logout(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
}


// Function Wrapper

struct HttpAuth {
    
    // login
    internal static func login(#email: String, password: String, apns: String) -> Void {
        RestConfig.storeUserid(email.md5())
        Alamofire.request(RestAuth.Login([
            "email"     : email,
            "password"  : password,
            "apns"      : apns
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
    
    // logout
    internal static func logout(#apns: String) -> Void {
        Alamofire.request(RestAuth.Logout([
            "apns"    : apns
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
    
}

