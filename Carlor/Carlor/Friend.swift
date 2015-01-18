//
//  Friend.swift
//  Carlor
//
//  Created by Li Zeng on 1/17/15.
//  Copyright (c) 2015 CarlorClub. All rights reserved.
//

import Foundation
import Alamofire

// Router

enum RestFriend: URLRequestConvertible {
    
    case CreateFriend([String: String])
    case TestFriend([String: String])
    case GetFriend()
    case DeleteFriend([String: String])
    
    var method: Alamofire.Method {
        switch self {
        case .CreateFriend:
            return .POST
        case .TestFriend:
            return .POST
        case .GetFriend:
            return .GET
        case .DeleteFriend:
            return .DELETE
        }
    }
    
    var path: String {
        switch self {
        case .CreateFriend:
            return "/api/v1/friend/create"
        case .TestFriend:
            return "/api/v1/friend/test_friend"
        case .GetFriend:
            return "/api/v1/friend/get"
        case .DeleteFriend:
            return "/api/v1/friend/delete"
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
        case .CreateFriend(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .TestFriend(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .DeleteFriend(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
}

// Function Wrapper

struct HttpFriend {
    
    // create a new Friend
    internal static func addFriend(
        #friend: String
        ) -> Void {
            Alamofire.request(RestFriend.CreateFriend([
                "type"          : "create",
                "friend"        : friend
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
    
    // test Friend
    internal static func testFriend(
        #friend: String
        ) -> Void {
            Alamofire.request(RestFriend.TestFriend([
                "type"              : "test",
                "choice"            : friend
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
    
    // get Friends
    internal static func getFriend() -> Void {
            Alamofire.request(RestFriend.GetFriend())
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
    
    // delete Friend
    internal static func deleteFriend(#friend: String) -> Void {
        Alamofire.request(RestFriend.DeleteFriend([
            "friend"    : friend
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
