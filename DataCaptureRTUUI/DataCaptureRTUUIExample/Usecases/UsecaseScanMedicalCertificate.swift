//
//  UsecaseScanEHIC.swift
//  DataCaptureRTUUIExample
//
//  Created by Yevgeniy Knizhnik on 12.08.19.
//  Copyright © 2019 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class UsecaseScanMedicalCertificate: Usecase, SBSDKUIMedicalCertificateScannerViewControllerDelegate {
    
    let result: ReviewableScanResult
    
    init(result: ReviewableScanResult) {
        self.result = result
    }
    
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        
        let configuration = SBSDKUIMedicalCertificateScannerConfiguration.defaultConfiguration
        configuration.textConfiguration.cancelButtonTitle = "Done"
        
        let scanner = SBSDKUIMedicalCertificateScannerViewController.create(configuration: configuration, delegate: self)
        
        presentViewController(scanner)
    }
    
    func medicalScannerViewControllerDidCancel(_ viewController: SBSDKUIMedicalCertificateScannerViewController) {
        didFinish()
    }
    
    func medicalScannerViewController(_ viewController: SBSDKUIMedicalCertificateScannerViewController,
                                      didFinishWith result: SBSDKMedicalCertificateScanningResult) {

        let title = "Medical certificate scanned"
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
