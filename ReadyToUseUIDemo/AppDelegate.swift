//
//  AppDelegate.swift
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 06.06.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // TODO set your license key here
        //ScanbotSDK.setLicense("YOUR_SCANBOT_SDK_LICENSE_KEY")
        ScanbotSDK.setLicense(
            "kQFXbr3Iak41fJVKnqcDzCs5lM4KDE" +
                "8NpxGE+EmlQm9lE1KjvPcwD9jKjygD" +
                "2jPSvLOKfLoRinND8gFrAFOhjSlsj0" +
                "2UDVl19hrOJvIdBgEPl0RtPw8yW3ZJ" +
                "7QejWgtLuc1qpf3SQkhUhKzV6Zklb+" +
                "VGnWTH3sITdXgr55l5zxT3MhuRmFP9" +
                "3tdEunx3tWTyd9oyZ2wue/ZIWBDB+1" +
                "xlizoA8yi/VK2GfPhgzFD539j42avM" +
                "xK6iuYu9Pyl4nwNbrNRkl4Auy4+Ulh" +
                "TArunU9xQuWENTtI/dxvRE2czTmsGr" +
                "xmw6IQaXfcadXijtd+afq22wI9Ar9v" +
                "3kLIjwoHbVug==\nU2NhbmJvdFNESw" +
                "ppby5zY2FuYm90LlJlYWR5VG9Vc2VV" +
                "SURlbW8KMTUzMzI1NDM5OQozMjc2Nw" +
            "ox\n")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

