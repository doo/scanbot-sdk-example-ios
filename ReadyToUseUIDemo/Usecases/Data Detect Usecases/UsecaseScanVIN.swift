//
//  UsecaseScanVIN.swift
//  ReadyToUseUIDemo
//
//  Created by Rana Sohaib on 21.08.23.
//  Copyright © 2023 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class UsecaseScanVIN: Usecase, SBSDKUIVINScannerViewControllerDelegate {
    
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)

        let configuration = SBSDKUIVINScannerConfiguration.default()
        configuration.textConfiguration.cancelButtonTitle = "Done"
        
        let scanner = SBSDKUIVINScannerViewController.createNew(with: configuration, andDelegate: self)
        presentViewController(scanner)
    }
    
    func vinScannerViewController(_ viewController: SBSDKUIVINScannerViewController,
                                  didFinishWith result: SBSDKVehicleIdentificationNumberScannerResult) {
        
        guard result.text.count > 0, viewController.isRecognitionEnabled == true else {
            return
        }
        let message = result.text
        let title = "VIN detected"
        
        UIAlertController.showInfoAlert(title, message: message, presenter: viewController, completion: nil)
    }
    
    func vinScannerViewControllerDidCancel(_ viewController: SBSDKUIVINScannerViewController) {
        didFinish()
    }
}
