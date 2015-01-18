//
//  User.swift
//  Carlor
//
//  Created by Li Zeng on 1/8/15.
//  Copyright (c) 2015 CarlorClub. All rights reserved.
//

import Foundation
import Alamofire

// Router

enum RestUser: URLRequestConvertible {
    
    case CreateUser([String: String])
    case UpdateUser([String: String])
    case GetCurrentUser()
    case GetSpecifiedUser(String)
    
    var method: Alamofire.Method {
        switch self {
        case .CreateUser:
            return .POST
        case .UpdateUser:
            return .PUT
        case .GetCurrentUser:
            return .GET
        case .GetSpecifiedUser:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .CreateUser:
            return "/api/v1/user/create"
        case .UpdateUser:
            return "/api/v1/user/update"
        case .GetCurrentUser:
            return "/api/v1/user/get"
        case .GetSpecifiedUser(let userid):
            return "/api/v1/user/get/\(userid)"
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
        case .CreateUser(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .UpdateUser(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
}

// Function Wrapper

struct HttpUser {
    
    // create a new user
    internal static func createUser(#email: String, password: String, firstname: String, lastname: String) -> Void {
        RestConfig.storeUserid(email.md5())
        Alamofire.request(RestUser.CreateUser([
                "email"     : email,
                "password"  : password,
                "firstname" : firstname,
                "lastname"  : lastname
            ]))
            .validate()
            .validate(contentType: ["application/json"])
            .responseJSON() { (req, res, data, err) -> Void in
                let json = JSON(data!)
                // proceed to create user
                if err == nil {
                    println(json)
                    RestConfig.storeUserid(json["userid"].stringValue)
                }
                // handle exception
                else {
                    let reason = json["reason"].stringValue
                    println(reason)
                }
        }
    // return void
    }
    
    // update user
    internal static func updateUser(
        #firstname: String,
        lastname: String,
        gender: String,
        college: String,
        major: String,
        birthday: String,
        password: String,
        phone: String,
        signature: String,
        driver: String,
        license: String
        ) -> Void {
        Alamofire.request(RestUser.UpdateUser([
            "firstname" : firstname,
            "lastname"  : lastname,
            "gender"    : gender,
            "college"   : college,
            "major"     : major,
            "birthday"  : birthday,
            "password"  : password,
            "phone"     : phone,
            "signature" : signature,
            "driver"    : driver,
            "license"   : license
            ]))
            .validate()
            .validate(contentType: ["application/json"])
            .responseJSON() { (req, res, data, err) -> Void in
                let json = JSON(data!)
                // proceed
                if err == nil {
                    RestConfig.storeUserid(json["userid"].stringValue)
                }
                // handle exception
                else {
                    let reason = json["reason"].stringValue
                    println(reason)
                }
        }
    // return void
    }
    
    // get current user
    internal static func getCurrentUser() -> Void {
        Alamofire.request(RestUser.GetCurrentUser())
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
    internal static func getSpecifiedUser(#userid: String) -> Void {
        Alamofire.request(RestUser.GetSpecifiedUser(userid))
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












