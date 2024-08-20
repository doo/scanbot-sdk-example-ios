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
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        
        let configuration = SBSDKUICheckRecognizerConfiguration.defaultConfiguration
        configuration.textConfiguration.cancelButtonTitle = "Done"
        
        let recognizer = SBSDKUICheckRecognizerViewController.create(configuration: configuration,
                                                                     delegate: self)
        presentViewController(recognizer)
    }
    
    func checkRecognizerViewController(_ viewController: SBSDKUICheckRecognizerViewController,
                                       didRecognizeCheck result: SBSDKCheckRecognizerResult) {
        let title = "Check recognized"
        let message = result.stringRepresentation
        UIAlertController.showInfoAlert(title, message: message, presenter: viewController, completion: nil)
    }
    
    func checkRecognizerViewControllerDidCancel(_ viewController: SBSDKUICheckRecognizerViewController) {
        didFinish()
    }
}
