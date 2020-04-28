//
//  UsecaseScanMRZ.swift
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 02.07.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import Foundation

class UsecaseScanMRZ: Usecase, SBSDKUIMRZScannerViewControllerDelegate {
    
    override func start(presenter: UIViewController) {

        super.start(presenter: presenter)

        let configuration = SBSDKUIMachineCodeScannerConfiguration.default()
        configuration.textConfiguration.cancelButtonTitle = "Done"

        let viewSize = presenter.view.frame.size
        let targetWidth = Double(viewSize.width - ((viewSize.width * 0.058) * 2))
        configuration.uiConfiguration.finderAspectRatio = SBSDKAspectRatio(width: targetWidth,
                                                                           andHeight: targetWidth * 0.3)

        let scanner = SBSDKUIMRZScannerViewController.createNew(with: configuration, andDelegate: self)

        self.presentViewController(scanner)
    }
    
    func mrzDetectionViewController(_ viewController: SBSDKUIMRZScannerViewController,
                                    didDetect zone: SBSDKMachineReadableZoneRecognizerResult) {
        let title = "MRZ detected"
        let message = zone.stringRepresentation()
        viewController.isRecognitionEnabled = false
        UIAlertController.showInfoAlert(title, message: message, presenter: viewController) {
            viewController.isRecognitionEnabled = true
        }
    }

    func mrzDetectionViewControllerDidCancel(_ viewController: SBSDKUIMRZScannerViewController) {
        self.didFinish()
    }
}
