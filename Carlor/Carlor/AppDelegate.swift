//
//  AppDelegate.swift
//  Carlor
//
//  Created by Li Zeng on 1/7/15.
//  Copyright (c) 2015 CarlorClub. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // test
//        HttpUser.createUser(
//            email: "lizeng@wustl.edu",
//            password: "123",
//            firstname: "Li",
//            lastname: "Zeng"
//        )

        
//        HttpActivate.resendEmail(userid: userid)
        
//        HttpActivate.activateUser(
//            userid: "lizeng@wustl.edu".md5(),
//            code: "29baf"
//        )

        
//        HttpClient.registerDevice(
//            deviceToken: "1ed5f02c7cea88968035c3d63bd35dbcec53bf62b6275dc2fda463a22290e258"
//        )
//        
//
//        HttpAuth.login(
//            email: "lizeng@wustl.edu",
//            password: "123",
//            apns: "1ed5f02c7cea88968035c3d63bd35dbcec53bf62b6275dc2fda463a22290e258"
//        )

//        HttpActivate.getActivateStatus(userid: userid)
//
//        HttpUser.updateUser(
//            firstname: "Li",
//            lastname: "Zeng",
//            gender: "male",
//            college: "WashU",
//            major: "CS",
//            birthday: ";",
//            password: "123",
//            phone: "314-808-6721",
//            signature: "this is a test",
//            driver: "no",
//            license: "2231"
//        )
//
        HttpUser.GetCurrentUser()
        HttpUser.GetSpecifiedUser(userid: "lizeng@wustl.edu".md5())
//
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

