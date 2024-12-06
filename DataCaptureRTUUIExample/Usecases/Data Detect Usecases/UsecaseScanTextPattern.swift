//
//  UsecaseScanTextData.swift
//  DataCaptureRTUUIExample
//
//  Created by Yevgeniy Knizhnik on 30.09.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class UsecaseScanTextPattern: Usecase, SBSDKUITextPatternScannerViewControllerDelegate {
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        
        let configuration = SBSDKUITextPatternScannerConfiguration.defaultConfiguration
        configuration.textConfiguration.cancelButtonTitle = "Done"
        let scanner = SBSDKUITextPatternScannerViewController.create(configuration: configuration, delegate: self)
        
        presentViewController(scanner)
    }
    
    func textPatternScannerViewController(_ controller: SBSDKUITextPatternScannerViewController,
                                          didFinish step: SBSDKUITextPatternScannerStep,
                                          with result: SBSDKUITextPatternScannerStepResult) {
        
        guard result.text.count > 0, controller.isScanningEnabled == true else {
            return
        }
        let message = result.text
        let title = "Text found"
        
        UIAlertController.showInfoAlert(title, message: message, presenter: controller, completion: nil)
    }
    
    func textPatternScannerViewControllerDidCancel(_ controller: SBSDKUITextPatternScannerViewController) {
        didFinish()
    }
}
