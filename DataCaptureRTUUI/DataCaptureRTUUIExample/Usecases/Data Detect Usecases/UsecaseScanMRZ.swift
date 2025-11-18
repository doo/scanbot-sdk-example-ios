//
//  UsecaseScanMRZ.swift
//  DataCaptureRTUUIExample
//
//  Created by Sebastian Husche on 02.07.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class UsecaseScanMRZ: Usecase {
    
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        
        let configuration = SBSDKUI2MRZScannerScreenConfiguration()
        
        let scanner = SBSDKUI2MRZScannerViewController.create(with: configuration) { [weak self] _, result, error in
            if let result {
                let title = "MRZ scanned"
                let message = result.rawMRZ
                UIAlertController.showInfoAlert(title, message: message, presenter: presenter, completion: nil)
            } else {
                self?.didFinish(error: error)
            }
        }
        presentViewController(scanner)
    }
}
