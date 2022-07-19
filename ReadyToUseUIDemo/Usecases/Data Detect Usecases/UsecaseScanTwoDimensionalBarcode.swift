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
        
        let configuration = SBSDKUIBarcodeScannerConfiguration.default()
        configuration.textConfiguration.cancelButtonTitle = "Done"
        configuration.behaviorConfiguration.barcodeImageGenerationType = SBSDKBarcodeImageGenerationType.fromVideoFrame
        let codeTypes = SBSDKUIMachineCodesCollection.twoDimensionalBarcodes()
        configuration.behaviorConfiguration.acceptedMachineCodeTypes = codeTypes
        
        let scanner = SBSDKUIBarcodeScannerViewController.createNew(with: configuration,
                                                                    andDelegate: self)
        
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
