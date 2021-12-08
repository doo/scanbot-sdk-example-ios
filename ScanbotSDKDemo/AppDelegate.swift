//
//  AppDelegate.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 30.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        ScanbotSDK.setupDefaultLicenseFailureHandler()
        
        // TODO Add your Scanbot SDK license here.
        // Please note: The Scanbot SDK will run without a license key for one minute per session!
        // After the trial period has expired all Scanbot SDK functions as well as the UI components will stop working.
        // You can get an unrestricted "no-strings-attached" trial license key for free.
        // Please submit the trial license form (https://scanbot.io/en/sdk/demo/trial) on our website by using
        // the Bundle Identifier "io.scanbot.example.sdk.ios.classic" of this example app.

        //ScanbotSDK.setLicense("YOUR_LICENSE_KEY")
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        ImageManager.shared.removeAllImages()
    }
}
