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
        ScanbotSDK.setLicense(
        "es1863Een2nSot1SmxyVqcEXJgTZXB" +
        "bkNznctG6B8kNj/0Dn1HOhyWxl02OY" +
        "jKqKm6mVQG6l/pet9usBiNnuzn3Iej" +
        "Ap/ICsmWYZ8d4wm72Br9OOor0YF5hF" +
        "yiuXUvKvZA1ys8jMvEf1S3+2C/7AR1" +
        "4/24VzdJsLYL1NnLSqGLappgCaTbrm" +
        "BJlJBP/dCi+AG8Uizp8OQ7aU7tQjii" +
        "joNUbcBUhwVFIo2uBzK/gvptSqewDh" +
        "v2q1SrXO/CQtjrc0yIX1C+aoZ50FTh" +
        "gbul1FmfHVNM3fqyiz8YdVxW92hKUa" +
        "ZRlf+MLVW3aIg3HlU/O51tzEaqGJdr" +
        "x0JYG2QKztaA==\nU2NhbmJvdFNESw" +
        "ppby5zY2FuYm90LmV4YW1wbGUuc2Rr" +
        "Lmlvcy5jbGFzc2ljCjE2Mzg2NjIzOT" +
        "kKODM4ODYwNwox\n")
        
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
