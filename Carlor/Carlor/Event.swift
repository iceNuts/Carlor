//
//  Event.swift
//  Carlor
//
//  Created by Li Zeng on 1/17/15.
//  Copyright (c) 2015 CarlorClub. All rights reserved.
//

import Foundation
import Alamofire

// Router

enum RestEvent: URLRequestConvertible {
    
    case CreateEvent([String: String])
    case UpdateEvent([String: String])
    case GetEvent(String, String, String)
    case GetSpecifiedEvent(String)
    
    var method: Alamofire.Method {
        switch self {
        case .CreateEvent:
            return .POST
        case .UpdateEvent:
            return .PUT
        case .GetEvent:
            return .GET
        case .GetSpecifiedEvent:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .CreateEvent:
            return "/api/v1/event/create"
        case .UpdateEvent:
            return "/api/v1/event/put"
        case .GetEvent(let eventid, let timestamp, let limit):
            return "/api/v1/event/\(eventid)/\(timestamp)/\(limit)"
        case .GetSpecifiedEvent(let eventid):
            return "/api/v1/event/\(eventid)"
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
        case .CreateEvent(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .UpdateEvent(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
}

// Function Wrapper

struct HttpEvent {
    
    // create a new event
    internal static func createEvent(
        #name: String,
        capacity: String,
        photo: String,
        start_time: String,
        end_time: String,
        detail: String,
        location: String
        ) -> Void {
            Alamofire.request(RestEvent.CreateEvent([
                "name"          : name,
                "capacity"      : capacity,
                "photo"         : photo,
                "start_time"    : start_time,
                "end_time"      : end_time,
                "detail"        : detail,
                "location"      : location
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
    
    // update event
    internal static func updateEvent(
        #type: String,
        choice: String,
        eventid: String,
        inbox_message_id: String,
        who_apply: String,
        who_invite: String,
        who_leave: String,
        attrs: String
        ) -> Void {
            Alamofire.request(RestEvent.UpdateEvent([
                "type"              : type,
                "choice"            : choice,
                "event_id"          : eventid,
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
    
    // get event by need
    internal static func getEvent(
        #eventid    : String,
        timestamp   : String,
        limit       : String
        ) -> Void {
            Alamofire.request(RestEvent.GetEvent(eventid, timestamp, limit))
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
    
    // get specified event
    internal static func getSpecifiedEvent(#eventid: String) -> Void {
        Alamofire.request(RestEvent.GetSpecifiedEvent(eventid))
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
