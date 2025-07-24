//
//  UsecaseScanVIN.swift
//  DataCaptureRTUUIExample
//
//  Created by Rana Sohaib on 21.08.23.
//  Copyright © 2023 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class UsecaseScanVIN: Usecase {
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        
        let configuration = SBSDKUI2VINScannerScreenConfiguration()
        
        let scanner = SBSDKUI2VINScannerViewController.create(with: configuration) { [weak self] result in
            if let result {
                guard !result.textResult.rawText.isEmpty || !result.barcodeResult.extractedVIN.isEmpty else {
                    return
                }
                let message = result.textResult.rawText + "\n" + result.barcodeResult.extractedVIN
                let title = "VIN detected"
                
                UIAlertController.showInfoAlert(title, message: message, presenter: presenter, completion: nil)

            } else {
                self?.didFinish()
            }
        }
        presentViewController(scanner)
    }
}
