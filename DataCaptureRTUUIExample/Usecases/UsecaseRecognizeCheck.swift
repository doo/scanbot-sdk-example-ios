//
//  UsecaseRecognizeCheck.swift
//  DataCaptureRTUUIExample
//
//  Created by Danil Voitenko on 03.05.22.
//  Copyright © 2022 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

final class UsecaseRecognizeCheck: Usecase, SBSDKUICheckRecognizerViewControllerDelegate {
    
    let result: ReviewableScanResult
    
    init(result: ReviewableScanResult) {
        self.result = result
    }
    
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        
        let configuration = SBSDKUICheckRecognizerConfiguration.defaultConfiguration
        configuration.textConfiguration.cancelButtonTitle = "Done"
        
        let recognizer = SBSDKUICheckRecognizerViewController.create(configuration: configuration,
                                                                     delegate: self)
        presentViewController(recognizer)
    }
    
    func checkRecognizerViewController(_ viewController: SBSDKUICheckRecognizerViewController,
                                       didRecognizeCheck result: SBSDKCheckRecognitionResult) {
        let title = "Check recognized"
        let message = result.toJson()
        UIAlertController.showInfoAlert(title, message: message, presenter: viewController) {
            if let navigationController = self.presenter as? UINavigationController {
                UsecaseBrowseImages(result: self.result).start(presenter: navigationController)
                viewController.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func checkRecognizerViewControllerDidCancel(_ viewController: SBSDKUICheckRecognizerViewController) {
        didFinish()
    }
}
