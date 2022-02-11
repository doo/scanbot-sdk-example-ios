//
//  UsecaseScanEHIC.swift
//  ReadyToUseUIDemo
//
//  Created by Yevgeniy Knizhnik on 12.08.19.
//  Copyright © 2019 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class UsecaseScanMedicalCertificate: Usecase, SBSDKUIMedicalCertificateScannerViewControllerDelegate {
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        
        let configuration = SBSDKUIMedicalCertificateScannerConfiguration.default()
        configuration.textConfiguration.cancelButtonTitle = "Done"
        
        let scanner = SBSDKUIMedicalCertificateScannerViewController.createNew(with: configuration, andDelegate: self)
        
        presentViewController(scanner)
    }
    
    func medicalScannerViewControllerDidCancel(_ viewController: SBSDKUIMedicalCertificateScannerViewController) {
        didFinish()
    }
    
    func medicalScannerViewController(_ viewController: SBSDKUIMedicalCertificateScannerViewController,
                                      didFinishWith result: SBSDKMedicalCertificateRecognizerResult) {

        let title = "Medical certificate detected"
        let message = result.stringRepresentation()
        UIAlertController.showInfoAlert(title, message: message, presenter: presenter!) {
            if let image = result.image {
                let page = SBSDKUIPage(image: image, polygon: nil, filter: SBSDKImageFilterTypeNone)
                let document = SBSDKUIDocument()
                document.add(page)
                if let navigationController = self.presenter as? UINavigationController {
                    UsecaseBrowseDocumentPages(document: document).start(presenter: navigationController)
                    viewController.presentingViewController?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
