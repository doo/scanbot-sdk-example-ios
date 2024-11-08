//
//  UsecaseScanEHIC.swift
//  DataCaptureRTUUIExample
//
//  Created by Yevgeniy Knizhnik on 12.08.19.
//  Copyright © 2019 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class UsecaseScanEHIC: Usecase, SBSDKUIHealthInsuranceCardRecognizerViewControllerDelegate {
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        
        let configuration = SBSDKUIHealthInsuranceCardRecognizerConfiguration.defaultConfiguration
        configuration.textConfiguration.cancelButtonTitle = "Done"
        
        let scanner = SBSDKUIHealthInsuranceCardRecognizerViewController.create(configuration: configuration, delegate: self)
        
        presentViewController(scanner)
    }
    
    func healthInsuranceCardDetectionViewController(_ viewController: SBSDKUIHealthInsuranceCardRecognizerViewController,
                                                    didDetectCard card: SBSDKEuropeanHealthInsuranceCardRecognitionResult) {
        let title = "Health card detected"
        let message = card.toJson()
        UIAlertController.showInfoAlert(title, message: message, presenter: viewController, completion: nil)
    }
    
    func healthInsuranceCardDetectionViewControllerDidCancel(_ viewController: SBSDKUIHealthInsuranceCardRecognizerViewController) {
        didFinish()
    }
}
