//
//  SceneDelegate.swift
//  ScanbotSDK Examples
//
//  Created by Sebastian Husche on 06.05.21.
//

import UIKit
import ScanbotSDK

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        runScreenshotAutomationIfNeeded(on: windowScene)
    }

    // MARK: - Documentation screenshot automation (temporary, not part of the examples)

    private func runScreenshotAutomationIfNeeded(on windowScene: UIWindowScene) {
        let environment = ProcessInfo.processInfo.environment
        guard let exampleName = environment["SBSHOT_EXAMPLE"] else { return }

        Scanbot.loggingEnabled = true

        if let mockImageName = environment["SBSHOT_MOCK_IMAGE"] {
            let mockImageURL = Bundle.main.url(forResource: mockImageName, withExtension: nil)
            print("SBSHOT: mock image \(mockImageName) -> \(String(describing: mockImageURL))")
            if let mockImageURL {
                Scanbot.cameraMockData = SBSDKCameraMockData(label: "Mock Camera",
                                                             imageURL: mockImageURL,
                                                             capturedImageURL: nil,
                                                             refreshOnEachFrame: false)
            }
        }

        if environment["SBSHOT_ORIENTATION"] == "landscape", #available(iOS 16.0, *) {
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscapeRight))
        }

        guard let exampleClass = NSClassFromString("ScanbotSDK_Examples.\(exampleName)") as? UIViewController.Type else {
            print("SBSHOT: unknown example \(exampleName)")
            return
        }

        let delay = Double(environment["SBSHOT_DELAY"] ?? "") ?? 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let navigationController = self?.window?.rootViewController as? UINavigationController else { return }
            navigationController.pushViewController(exampleClass.init(), animated: false)
            if environment["SBSHOT_ORIENTATION"] == "landscape", #available(iOS 16.0, *) {
                windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscapeRight))
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

