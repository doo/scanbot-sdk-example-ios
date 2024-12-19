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
        
        var message = ""
        if result.barcodeResult.status == .success && result.barcodeResult.extractedVIN.count > 0 {
            message = result.barcodeResult.extractedVIN
        } else if result.textResult.validationSuccessful && !result.textResult.rawText.isEmpty {
            message = result.textResult.rawText
        } else {
            return
        }
        
        let title = "VIN detected"
        
        UIAlertController.showInfoAlert(title, message: message, presenter: viewController, completion: nil)
    }
    
    func vinScannerViewControllerDidCancel(_ viewController: SBSDKUIVINScannerViewController) {
        didFinish()
    }
}
