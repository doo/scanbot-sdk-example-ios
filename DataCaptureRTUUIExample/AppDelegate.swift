//
//  AppDelegate.swift
//  DataCaptureRTUUIExample
//
//  Created by Sebastian Husche on 06.06.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // TODO: Set your license key here
        // Scanbot.setLicense("YOUR_SCANBOT_SDK_LICENSE_KEY")
        
        // Setup the default license failure handler. In case of expired license or expired trial period it will present an alert and terminate the app.
        // See also Scanbot.setLicenseFailureHandler(handler) to setup a custom handler.
        Scanbot.setupDefaultLicenseFailureHandler()
        
        // Demonstration of global SBSDKUI image storage encryption.
        let encrypter = SBSDKAESEncrypter(password: "EnterStrongPassphraseHereInsteadOfThisRidiculousText", mode: .AES128)
        ScanbotUI.defaultImageStoreEncrypter = encrypter
        // Now all images written to the disk are encrypted.
        
        if #available(iOS 15.0, *) {
                let navBarAppearance = UINavigationBarAppearance()
                navBarAppearance.configureWithOpaqueBackground()
                //Configure additional customizations here
                UINavigationBar.appearance().standardAppearance = navBarAppearance
                UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        }
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

