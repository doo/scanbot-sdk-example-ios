//
//  UsecaseScanLicensePlate.swift
//  DataCaptureRTUUIExample
//
//  Created by Danil Voitenko on 17.03.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class UsecaseScanLicensePlate: Usecase, SBSDKUILicensePlateScannerViewControllerDelegate {
    
    let result: ReviewableScanResult
    
    init(result: ReviewableScanResult) {
        self.result = result
    }
    
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)

        let configuration = SBSDKUILicensePlateScannerConfiguration.defaultConfiguration
        configuration.textConfiguration.cancelButtonTitle = "Done"
        let scanner = SBSDKUILicensePlateScannerViewController.create(configuration: configuration, delegate: self)
        presentViewController(scanner)
    }

    func licensePlateScanner(_ controller: SBSDKUILicensePlateScannerViewController,
                             didRecognizeLicensePlate result: SBSDKLicensePlateScannerResult) {
        guard result.validationSuccessful else {
            return
        }
        let message = result.licensePlate
        let title = "License plate found"
        UIAlertController.showInfoAlert(title, message: message, presenter: presenter!) {
            if let image = result.croppedImage?.toUIImage() {
                self.result.images.append(image)
                if let navigationController = self.presenter as? UINavigationController {
                    UsecaseBrowseImages(result: self.result).start(presenter: navigationController)
                    controller.presentingViewController?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    func licensePlateScannerDidCancel(_ controller: SBSDKUILicensePlateScannerViewController) {
        didFinish()
    }
}
