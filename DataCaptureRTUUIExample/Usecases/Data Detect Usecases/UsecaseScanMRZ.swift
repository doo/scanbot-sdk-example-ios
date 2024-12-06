//
//  UsecaseScanMRZ.swift
//  DataCaptureRTUUIExample
//
//  Created by Sebastian Husche on 02.07.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class UsecaseScanMRZ: Usecase, SBSDKUIMRZScannerViewControllerDelegate {
    
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        
        let configuration = SBSDKUIMRZScannerConfiguration.defaultConfiguration
        configuration.textConfiguration.cancelButtonTitle = "Done"
        
        let scanner = SBSDKUIMRZScannerViewController.create(configuration: configuration, delegate: self)
        
        presentViewController(scanner)
    }
    
    func mrzScannerViewController(_ viewController: SBSDKUIMRZScannerViewController,
                                  didScan zone: SBSDKMRZScannerResult) {
        let title = "MRZ scanned"
        let message = zone.toJson()
        UIAlertController.showInfoAlert(title, message: message, presenter: viewController, completion: nil)
    }
    
    func mrzScanningViewControllerDidCancel(_ viewController: SBSDKUIMRZScannerViewController) {
        didFinish()
    }
}
