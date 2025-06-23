//
//  AppDelegate.swift
//  DocumentScannerRTUUIExample
//
//  Created by Rana Sohaib on 23.08.23.
//

import UIKit
import ScanbotSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Scanbot.setupDefaultLicenseFailureHandler()
        
        // TODO Add your Scanbot SDK license here.
        // Please note: The Scanbot SDK will run without a license key for one minute per session!
        // After the trial period has expired all Scanbot SDK functions as well as the UI components will stop working.
        // You can get an unrestricted "no-strings-attached" trial license key for free.
        // Please submit the trial license form (https://scanbot.io/en/sdk/demo/trial) on our website by using
        // the Bundle Identifier "io.scanbot.example.documentsdk.usecases.ios" of this example app.

        //Scanbot.setLicense("YOUR_LICENSE_KEY")
        
        // Apply a custom navigation style.
        UINavigationBar.applyCustomNavigationStyle()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
