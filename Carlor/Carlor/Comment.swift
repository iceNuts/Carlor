//
//  Comment.swift
//  Carlor
//
//  Created by Li Zeng on 1/17/15.
//  Copyright (c) 2015 CarlorClub. All rights reserved.
//

import Foundation
import Alamofire

// Router

enum RestComment: URLRequestConvertible {
    
    case CreateComment([String: String])
    case EditComment([String: String])
    case GetComment(String, String, String)
    case DeleteComment([String: String])
    
    var method: Alamofire.Method {
        switch self {
        case .CreateComment:
            return .POST
        case .EditComment:
            return .PUT
        case .GetComment:
            return .GET
        case .DeleteComment:
            return .DELETE
        }
    }
    
    var path: String {
        switch self {
        case .CreateComment:
            return "/api/v1/comment/create"
        case .EditComment:
            return "/api/v1/comment/edit"
        case .GetComment(let eventid, let timestamp, let limit):
            return "/api/v1/comment/\(eventid)/\(timestamp)/\(limit)"
        case .DeleteComment:
            return "/api/v1/comment/delete"
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
        case .CreateComment(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .EditComment(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .DeleteComment(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
}

// Function Wrapper

struct HttpComment {
    
    // create a new comment
    internal static func createComment(
        #eventid: String,
        creatorid: String,
        contentType: String,
        contentMessage: String
        ) -> Void {
        Alamofire.request(RestComment.CreateComment([
            "event_id"      : eventid,
            "creator_id"    : creatorid,
            "content"       : "{\"type\": \(contentType), \"message\": \(contentMessage)}",
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
    
    // update comment
    internal static func editComment(
        #commentid: String,
        content: String
        ) -> Void {
            Alamofire.request(RestComment.EditComment([
                "comment_id"    : commentid,
                "content"       : content
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
    
    // get comment by need
    internal static func getComment(
        #eventid    : String,
        timestamp   : String,
        limit       : String
        ) -> Void {
        Alamofire.request(RestComment.GetComment(eventid, timestamp, limit))
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
    
    // delete a comment
    internal static func deleteComment(#commentid: String) -> Void {
        Alamofire.request(RestComment.DeleteComment([
            "comment_id"    : commentid
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












