//
//  SceneDelegate.swift
//  DataCaptureRTUUIExample
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
        
        // TODO: Set your license key here
        // Scanbot.setLicense("YOUR_SCANBOT_SDK_LICENSE_KEY")
        
        // Setup the default license failure handler. In case of expired license or expired trial period it will present an alert and terminate the app.
        // See also Scanbot.setLicenseFailureHandler(handler) to setup a custom handler.
        Scanbot.setupDefaultLicenseFailureHandler()
        
        // Demonstration of global image storage encryption.
        let provider = SBSDKCryptingProvider {
            return SBSDKAESEncrypter(password: "EnterStrongPassphraseHereInsteadOfThisRidiculousText", mode: .AES128)
        }
        Scanbot.defaultCryptingProvider = provider
        // Now all images written to the disk are encrypted.
        
        if #available(iOS 15.0, *) {
                let navBarAppearance = UINavigationBarAppearance()
                navBarAppearance.configureWithOpaqueBackground()
                //Configure additional customizations here
                UINavigationBar.appearance().standardAppearance = navBarAppearance
                UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        }
    }
}
