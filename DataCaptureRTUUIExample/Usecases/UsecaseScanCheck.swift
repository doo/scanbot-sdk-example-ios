//
//  UsecaseRecognizeCheck.swift
//  DataCaptureRTUUIExample
//
//  Created by Danil Voitenko on 03.05.22.
//  Copyright © 2022 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

final class UsecaseScanCheck: Usecase, SBSDKUICheckScannerViewControllerDelegate {
    
    let result: ReviewableScanResult
    
    init(result: ReviewableScanResult) {
        self.result = result
    }
    
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        
        let configuration = SBSDKUICheckScannerConfiguration.defaultConfiguration
        configuration.textConfiguration.cancelButtonTitle = "Done"
        
        let Scanner = SBSDKUICheckScannerViewController.create(configuration: configuration,
                                                                     delegate: self)
        presentViewController(Scanner)
    }
    
    func checkScannerViewController(_ viewController: SBSDKUICheckScannerViewController,
                                       didScanCheck result: SBSDKCheckScanningResult) {
        let title = "Check scanned"
        let message = result.toJson()
        UIAlertController.showInfoAlert(title, message: message, presenter: viewController) {
            if let navigationController = self.presenter as? UINavigationController {
                UsecaseBrowseImages(result: self.result).start(presenter: navigationController)
                viewController.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func checkScannerViewControllerDidCancel(_ viewController: SBSDKUICheckScannerViewController) {
        didFinish()
    }
}
