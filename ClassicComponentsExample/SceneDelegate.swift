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
        
        Scanbot.setupDefaultLicenseFailureHandler()
        
        if #available(iOS 15.0, *) {
                let navBarAppearance = UINavigationBarAppearance()
                navBarAppearance.configureWithOpaqueBackground()
                //Configure additional customizations here
                UINavigationBar.appearance().standardAppearance = navBarAppearance
                UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        }
    }
}
