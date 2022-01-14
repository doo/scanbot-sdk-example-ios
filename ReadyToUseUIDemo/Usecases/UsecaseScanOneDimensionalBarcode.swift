//
//  UsecaseScanOneDimensionalBarcode.swift
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 02.07.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class UsecaseScanOneDimensionalBarcode: Usecase, SBSDKUIBarcodeScannerViewControllerDelegate {
    
    override func start(presenter: UIViewController) {

        super.start(presenter: presenter)

        let configuration = SBSDKUIBarcodeScannerConfiguration.default()
        configuration.textConfiguration.cancelButtonTitle = "Done"
        configuration.uiConfiguration.finderAspectRatio = SBSDKAspectRatio(width: 2, andHeight: 1)
        configuration.uiConfiguration.allowedInterfaceOrientations = .landscape
        
        
        let codeTypes = SBSDKUIMachineCodesCollection.oneDimensionalBarcodes()
        
        let scanner = SBSDKUIBarcodeScannerViewController.createNew(withAcceptedMachineCodeTypes: codeTypes,
                                                                    configuration: configuration,
                                                                    andDelegate: self)
        
        self.presentViewController(scanner)
    }
    
    func qrBarcodeDetectionViewController(_ viewController: SBSDKUIBarcodeScannerViewController,
                                          didDetect barcodeResults: [SBSDKBarcodeScannerResult]) {
                
        viewController.isRecognitionEnabled = false
        viewController.dismiss(animated: true) {
            if let navigationController = self.presenter as? UINavigationController,
               !barcodeResults.isEmpty {
                let controller = BarcodeResultListViewController.make(with: barcodeResults)
                navigationController.pushViewController(controller, animated: true)
            }
        }
    }
    
    func qrBarcodeDetectionViewControllerDidCancel(_ viewController: SBSDKUIBarcodeScannerViewController) {
        self.didFinish()
    }
}
