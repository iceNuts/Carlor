//
//  Chatgroup.swift
//  Carlor
//
//  Created by Li Zeng on 1/10/15.
//  Copyright (c) 2015 CarlorClub. All rights reserved.
//

import Foundation

import Alamofire


// Router

enum RestChatgroup: URLRequestConvertible {
    
    case CreateChatgroup([String: String])
    case UpdateChatgroup([String: String])
    case GetChatgroup(String)
    case DeleteChatgroup([String: String])
    
    var method: Alamofire.Method {
        switch self {
        case .CreateChatgroup:
            return .POST
        case .UpdateChatgroup:
            return .PUT
        case .GetChatgroup:
            return .GET
        case .DeleteChatgroup:
            return .DELETE
        }
    }
    
    var path: String {
        switch self {
        case .CreateChatgroup:
            return "/api/v1/chatgroup/create"
        case .UpdateChatgroup:
            return "/api/v1/chatgroup/put"
        case .GetChatgroup(let chatgroupid):
            return "/api/v1/chatgroup/get/\(chatgroupid)"
        case .DeleteChatgroup(let userid):
            return "/api/v1/chatgroup/delete"
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
        case .CreateChatgroup(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .UpdateChatgroup(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .DeleteChatgroup(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
}



// Function Wrapper

struct HttpChatgroup {
    
    // create a new user
    internal static func createChatgroup(
        #eventid: String,
        name: String,
        memberlist: String,
        capacity: String,
        photo: String
        ) -> Void {
        Alamofire.request(RestChatgroup.CreateChatgroup([
            "eventid"       : eventid,
            "name"          : name,
            "memberlist"    : memberlist,
            "capacity"      : capacity,
            "photo"         : photo
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
    
    // update user
    internal static func updateChatgroup(
        #type: String,
        choice: String,
        chatgroup_id: String,
        inbox_message_id: String,
        who_apply: String,
        who_invite: String,
        who_leave: String,
        attrs: String
        ) -> Void {
            Alamofire.request(RestChatgroup.UpdateChatgroup([
                "type"              : type,
                "choice"            : choice,
                "chatgroup_id"      : chatgroup_id,
                "inbox_message_id"  : inbox_message_id,
                "who_apply"         : who_apply,
                "who_invite"        : who_invite,
                "who_leave"         : who_leave,
                "attrs"             : attrs
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
    
    // get current user
    internal static func getChatgroup(
        #chatgroupid: String
        ) -> Void {
        Alamofire.request(RestChatgroup.GetChatgroup(chatgroupid))
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
    internal static func deleteChatgroup(
        #type: String,
        chatgroupid: String,
        creatorid: String,
        whoToKickOut: String
        ) -> Void {
        Alamofire.request(RestChatgroup.DeleteChatgroup([
            "type"              : type,
            "chatgroup_id"      : chatgroupid,
            "creator_id"        : creatorid,
            "who_to_kick_out"   : whoToKickOut
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









