//
//  UsecaseScanQRCode.swift
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 02.07.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import Foundation

class UsecaseScanQRCode: Usecase, SBSDKUIBarcodeScannerViewControllerDelegate {
    
    override func start(presenter: UIViewController) {
        
        super.start(presenter: presenter)
        
        let configuration = SBSDKUIMachineCodeScannerConfiguration.default()
        let codeTypes = SBSDKUIMachineCodesCollection.twoDimensionalBarcodes()
        
        let scanner = SBSDKUIBarcodeScannerViewController.createNew(withAcceptedMachineCodeTypes: codeTypes,
                                                                    configuration: configuration,
                                                                    andDelegate: self)
        
        self.presentViewController(scanner)
    }
    
    func qrBarcodeDetectionViewController(_ viewController: SBSDKUIBarcodeScannerViewController,
                                          didDetect code: SBSDKMachineReadableCode) {

        guard let message = code.stringValue else { return }
        let title = code.isQRCode() ? "QR code detected" : "Barcode detected"
        
        viewController.isRecognitionEnabled = false
        UIAlertController.showInfoAlert(title, message: message, presenter: viewController) {
            viewController.isRecognitionEnabled = true
        }
    }
    
    func qrBarcodeDetectionViewControllerDidCancel(_ viewController: SBSDKUIBarcodeScannerViewController) {
        self.didFinish()
    }
}
