//
//  UsecaseScanLicensePlate.swift
//  ReadyToUseUIDemo
//
//  Created by Danil Voitenko on 17.03.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class UsecaseScanLicensePlate: Usecase, SBSDKUILicensePlateScannerViewControllerDelegate {
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)

        let configuration = SBSDKUILicensePlateScannerConfiguration.defaultConfiguration
        configuration.textConfiguration.cancelButtonTitle = "Done"
        let scanner = SBSDKUILicensePlateScannerViewController.create(configuration: configuration, delegate: self)
        presentViewController(scanner)
    }

    func licensePlateScanner(_ controller: SBSDKUILicensePlateScannerViewController,
                             didRecognizeLicensePlate result: SBSDKLicensePlateScannerResult) {
        guard result.isValidationSuccessful else {
            return
        }
        let message = result.licensePlate
        let title = "License plate found"
        UIAlertController.showInfoAlert(title, message: message, presenter: presenter!, completion: nil)
    }

    func licensePlateScannerDidCancel(_ controller: SBSDKUILicensePlateScannerViewController) {
        didFinish()
    }
}
