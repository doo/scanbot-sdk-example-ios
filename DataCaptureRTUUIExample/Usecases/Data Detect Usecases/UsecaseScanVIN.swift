//
//  UsecaseScanVIN.swift
//  DataCaptureRTUUIExample
//
//  Created by Rana Sohaib on 21.08.23.
//  Copyright © 2023 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class UsecaseScanVIN: Usecase, SBSDKUIVINScannerViewControllerDelegate {
    
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)

        let configuration = SBSDKUIVINScannerConfiguration.defaultConfiguration
        configuration.textConfiguration.cancelButtonTitle = "Done"
        
        let scanner = SBSDKUIVINScannerViewController.create(configuration: configuration, delegate: self)
        presentViewController(scanner)
    }
    
    func vinScannerViewController(_ viewController: SBSDKUIVINScannerViewController,
                                  didFinishWith result: SBSDKVINScannerResult) {
        
        guard viewController.isRecognitionEnabled else {
            return
        }
        
        var message = ""
        if !(result.textResult.validationSuccessful || result.barcodeResult.status == .barcodeExtractionDisabled) {
            if !(result.barcodeResult.status == .success) {
                return
            } else {
                message = result.barcodeResult.extractedVIN
            }
        } else {
            message = result.textResult.rawText
        }

        let title = "VIN detected"
        
        UIAlertController.showInfoAlert(title, message: message, presenter: viewController, completion: nil)
    }
    
    func vinScannerViewControllerDidCancel(_ viewController: SBSDKUIVINScannerViewController) {
        didFinish()
    }
}
