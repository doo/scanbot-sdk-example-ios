//
//  UsecaseScanTextData.swift
//  DataCaptureRTUUIExample
//
//  Created by Yevgeniy Knizhnik on 30.09.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class UsecaseScanTextPattern: Usecase {
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        
        let configuration = SBSDKUI2TextPatternScannerScreenConfiguration()
        
        let scanner = SBSDKUI2TextPatternScannerViewController.create(with: configuration) { [weak self] _, result, error in
            if let result {
                guard result.rawText.count > 0 else {
                    return
                }
                let message = result.rawText
                let title = "Text found"
                
                UIAlertController.showInfoAlert(title, message: message, presenter: presenter, completion: nil)

            } else {
                self?.didFinish(error: error)
            }
        }        
        presentViewController(scanner)
    }
}
