//
//  SceneDelegate.swift
//  DocumentScannerRTUUIExample
//
//  Created by Rana Sohaib on 23.08.23.
//

import UIKit
import ScanbotSDK

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
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
    }
}
