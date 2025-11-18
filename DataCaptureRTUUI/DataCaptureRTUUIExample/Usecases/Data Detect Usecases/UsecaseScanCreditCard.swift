//
//  UsecaseScanCreditCard.swift
//  DataCaptureRTUUIExample
//
//  Created by Seifeddine Bouzid on 11.02.25.
//  Copyright © 2025 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class UsecaseScanCreditCard: Usecase {
    
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        
        let configuration = SBSDKUI2CreditCardScannerScreenConfiguration()
        
        let scanner = SBSDKUI2CreditCardScannerViewController.create(with: configuration) { [weak self] _, result, error  in
            if let result {
                let title = "Credit Card scanned"
                var message = "Recognition Status: \(result.recognitionStatus.stringValue)"
                
                let fields = result.creditCard?.fields.compactMap {
                    "\($0.type.displayText ?? ""): \($0.value?.text ?? "")"
                } ?? []
                message += "\n" + fields.joined(separator: "\n")
                
                UIAlertController.showInfoAlert(title, message: message, presenter: presenter, completion: nil)
            } else {
                self?.didFinish(error: error)
            }
        }        
        presentViewController(scanner)
    }
}

extension SBSDKCreditCardScanningStatus {
    var stringValue: String {
        switch self {
        case .success:
            return "Success"
        case .errorNothingFound:
            return "ErrorNothingFound"
        case .incomplete:
            return "Incomplete"
        @unknown default:
            return "\(self.rawValue)"
        }
    }
}
