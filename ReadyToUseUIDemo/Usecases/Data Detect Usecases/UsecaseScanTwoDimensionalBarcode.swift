//
//  UsecaseScanTwoDimensionalBarcode.swift
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 02.07.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class UsecaseScanTwoDimensionalBarcode: Usecase, SBSDKUIBarcodeScannerViewControllerDelegate {
    
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        
        let configuration = SBSDKUIBarcodeScannerConfiguration.defaultConfiguration
        configuration.textConfiguration.cancelButtonTitle = "Done"
        configuration.behaviorConfiguration.barcodeImageGenerationType = SBSDKBarcodeImageGenerationType.fromVideoFrame
        let codeTypes = SBSDKBarcodeType.twoDTypes
        configuration.behaviorConfiguration.acceptedBarcodeTypes = codeTypes
        
        let scanner = SBSDKUIBarcodeScannerViewController.create(configuration: configuration, 
                                                                 delegate: self)
        
        presentViewController(scanner)
    }
    
    func qrBarcodeDetectionViewController(_ viewController: SBSDKUIBarcodeScannerViewController,
                                          didDetect barcodeResults: [SBSDKBarcodeScannerResult]) {
        if !barcodeResults.isEmpty {
            viewController.isRecognitionEnabled = false
            if let navigationController = presenter as? UINavigationController {
                let controller = BarcodeResultListViewController.make(with: barcodeResults)
                navigationController.pushViewController(controller, animated: false)
                viewController.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
        
    func qrBarcodeDetectionViewControllerDidCancel(_ viewController: SBSDKUIBarcodeScannerViewController) {
        didFinish()
    }
}
