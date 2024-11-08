//
//  UsecaseScanEHIC.swift
//  DataCaptureRTUUIExample
//
//  Created by Yevgeniy Knizhnik on 12.08.19.
//  Copyright © 2019 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class UsecaseScanMedicalCertificate: Usecase, SBSDKUIMedicalCertificateRecognizerViewControllerDelegate {
    
    let result: ReviewableScanResult
    
    init(result: ReviewableScanResult) {
        self.result = result
    }
    
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        
        let configuration = SBSDKUIMedicalCertificateRecognizerConfiguration.defaultConfiguration
        configuration.textConfiguration.cancelButtonTitle = "Done"
        
        let scanner = SBSDKUIMedicalCertificateRecognizerViewController.create(configuration: configuration, delegate: self)
        
        presentViewController(scanner)
    }
    
    func medicalScannerViewControllerDidCancel(_ viewController: SBSDKUIMedicalCertificateRecognizerViewController) {
        didFinish()
    }
    
    func medicalScannerViewController(_ viewController: SBSDKUIMedicalCertificateRecognizerViewController,
                                      didFinishWith result: SBSDKMedicalCertificateRecognitionResult) {

        let title = "Medical certificate detected"
        let message = result.toJson()
        UIAlertController.showInfoAlert(title, message: message, presenter: presenter!) {
            if let image = result.croppedImage?.toUIImage() {
                self.result.images.append(image)
                if let navigationController = self.presenter as? UINavigationController {
                    UsecaseBrowseImages(result: self.result).start(presenter: navigationController)
                    viewController.presentingViewController?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
