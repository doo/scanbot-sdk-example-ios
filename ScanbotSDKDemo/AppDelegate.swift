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
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        let imageStorageManager = ImageStorageManager.shared
        imageStorageManager.originalImageStorage.removeAllImages()
        imageStorageManager.documentImageStorage.removeAllImages()
        print("Original Image Storage: \(imageStorageManager.originalImageStorage.imageCount)\n" +
              "Document Image Storage: \(imageStorageManager.documentImageStorage.imageCount)")
    }
}
