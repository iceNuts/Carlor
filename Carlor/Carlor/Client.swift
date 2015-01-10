//
//  Client.swift
//  Carlor
//
//  Created by Li Zeng on 1/10/15.
//  Copyright (c) 2015 CarlorClub. All rights reserved.
//

import Foundation

import Alamofire

// Router

enum RestClient: URLRequestConvertible {
    
    case RegisterDevice([String: String])
    
    var method: Alamofire.Method {
        switch self {
        case .RegisterDevice:
            return .POST
        }
    }
    
    var path: String {
        switch self {
        case .RegisterDevice:
            return "/api/v1/client/registry"
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
        case .RegisterDevice(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
}


// Function Wrapper

struct HttpClient {
    
    // create a new user
    internal static func registerDevice(#deviceToken: String) -> Void {
        Alamofire.request(RestClient.RegisterDevice([
            "deviceToken"   : deviceToken
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
}



