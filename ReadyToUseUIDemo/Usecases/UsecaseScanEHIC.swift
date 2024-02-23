//
//  UsecaseScanEHIC.swift
//  ReadyToUseUIDemo
//
//  Created by Yevgeniy Knizhnik on 12.08.19.
//  Copyright © 2019 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class UsecaseScanEHIC: Usecase, SBSDKUIHealthInsuranceCardScannerViewControllerDelegate {
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        
        let configuration = SBSDKUIHealthInsuranceCardScannerConfiguration.defaultConfiguration
        
        let recognizerParameters = configuration.behaviorConfiguration.recognizerParameters
        recognizerParameters.minBirthYear = 1920
        configuration.behaviorConfiguration.recognizerParameters = recognizerParameters
        
        configuration.textConfiguration.cancelButtonTitle = "Done"
        
        let scanner = SBSDKUIHealthInsuranceCardScannerViewController.create(configuration: configuration, delegate: self)
        
        presentViewController(scanner)
    }
    
    func healthInsuranceCardDetectionViewController(_ viewController: SBSDKUIHealthInsuranceCardScannerViewController,
                                                    didDetectCard card: SBSDKHealthInsuranceCardRecognitionResult) {
        let title = "Health card detected"
        let message = card.stringRepresentation
        UIAlertController.showInfoAlert(title, message: message, presenter: viewController, completion: nil)
    }
    
    func healthInsuranceCardDetectionViewControllerDidCancel(_ viewController: SBSDKUIHealthInsuranceCardScannerViewController) {
        didFinish()
    }
}
