//
//  RestConfig.swift
//  Carlor
//
//  Created by Li Zeng on 1/8/15.
//  Copyright (c) 2015 CarlorClub. All rights reserved.
//

import Foundation

struct RestConfig {
    
    internal static let baseURLString = "http://ec2-50-112-138-67.us-west-2.compute.amazonaws.com"
    
    internal static func storeAuthToken(token: String) -> Void {
        var userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(token, forKey: "AuthToken")
        userDefaults.synchronize()
    }
    
    internal static func readAuthToken() -> String? {
        var userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        return userDefaults.valueForKey("AuthToken") as? String
    }
    
    internal static func storeUserid(userid: String) -> Void {
        var userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(userid, forKey: "Userid")
        userDefaults.synchronize()
    }

    internal static func readUserid() -> String? {
        var userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        return userDefaults.valueForKey("Userid") as? String
    }
}
