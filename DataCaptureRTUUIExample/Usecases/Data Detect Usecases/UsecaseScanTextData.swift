//
//  UsecaseScanTextData.swift
//  DataCaptureRTUUIExample
//
//  Created by Yevgeniy Knizhnik on 30.09.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class UsecaseScanTextData: Usecase, SBSDKUITextDataScannerViewControllerDelegate {
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        
        let configuration = SBSDKUITextDataScannerConfiguration.defaultConfiguration
        configuration.textConfiguration.cancelButtonTitle = "Done"
        let scanner = SBSDKUITextDataScannerViewController.create(configuration: configuration, delegate: self)
        
        presentViewController(scanner)
    }
    
    func textLineScannerViewController(_ controller: SBSDKUITextDataScannerViewController,
                                          didFinish step: SBSDKUITextDataScannerStep,
                                          with result: SBSDKUITextDataScannerStepResult) {
        
        guard result.text.count > 0, controller.isRecognitionEnabled == true else {
            return
        }
        let message = result.text
        let title = "Text found"
        
        UIAlertController.showInfoAlert(title, message: message, presenter: controller, completion: nil)
    }
    
    func textLineScannerViewControllerDidCancel(_ controller: SBSDKUITextDataScannerViewController) {
        didFinish()
    }
}
