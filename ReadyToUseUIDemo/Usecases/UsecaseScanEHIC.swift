//
//  UsecaseScanEHIC.swift
//  ReadyToUseUIDemo
//
//  Created by Yevgeniy Knizhnik on 12.08.19.
//  Copyright © 2019 doo GmbH. All rights reserved.
//

import Foundation

class UsecaseScanEHIC: Usecase, SBSDKUIHealthInsuranceCardScannerViewControllerDelegate {
    override func start(presenter: UIViewController) {
        
        super.start(presenter: presenter)
        
        let configuration = SBSDKUIHealthInsuranceCardScannerConfiguration.default()
        configuration.textConfiguration.cancelButtonTitle = "Done"
        
        let scanner = SBSDKUIHealthInsuranceCardScannerViewController.createNew(with: configuration, andDelegate: self)
        
        self.presentViewController(scanner)
    }
    
    func healthInsuranceCardDetectionViewController(_ viewController: SBSDKUIHealthInsuranceCardScannerViewController,
                                                    didDetectCard card: SBSDKHealthInsuranceCardRecognitionResult) {
        let title = "Health card detected"
        let message = card.stringRepresentation()
        viewController.isRecognitionEnabled = false
        UIAlertController.showInfoAlert(title, message: message, presenter: viewController) {
            viewController.isRecognitionEnabled = true
        }
    }
    
    func healthInsuranceCardDetectionViewControllerDidCancel(_ viewController: SBSDKUIHealthInsuranceCardScannerViewController) {
        self.didFinish()
    }
}
