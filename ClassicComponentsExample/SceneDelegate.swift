//
//  SceneDelegate.swift
//  ClassicComponentsExample
//
//  Created by seifeddine bouzid on 16/6/2025.
//  Copyright © 2025 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
    
        guard let _ = (scene as? UIWindowScene) else { return }
        
        ImageManager.shared.removeAllImages()
        
        Scanbot.setupDefaultLicenseFailureHandler()
        
        // TODO Add your Scanbot SDK license here.
        // Please note: The Scanbot SDK will run without a license key for one minute per session!
        // After the trial period has expired all Scanbot SDK functions as well as the UI components will stop working.
        // You can get an unrestricted "no-strings-attached" trial license key for free.
        // Please submit the trial license form (https://scanbot.io/en/sdk/demo/trial) on our website by using
        // the Bundle Identifier "io.scanbot.example.sdk.ios.classic" of this example app.
        //Scanbot.setLicense("YOUR_LICENSE_KEY")
        
        if #available(iOS 15.0, *) {
                let navBarAppearance = UINavigationBarAppearance()
                navBarAppearance.configureWithOpaqueBackground()
                //Configure additional customizations here
                UINavigationBar.appearance().standardAppearance = navBarAppearance
                UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        }
    }
}
