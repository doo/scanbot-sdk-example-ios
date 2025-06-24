//
//  UsecaseRecognizeCheck.swift
//  DataCaptureRTUUIExample
//
//  Created by Danil Voitenko on 03.05.22.
//  Copyright © 2022 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

final class UsecaseScanCheck: Usecase {
    
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        
        let configuration = SBSDKUI2CheckScannerScreenConfiguration()
        
        let scanner = SBSDKUI2CheckScannerViewController.create(with: configuration) { [weak self] result in
            if let result {
                let title = "Check found"
                var message = "Recognition Status: \(result.recognitionStatus.stringValue)"
                let fields = result.check?.fields.compactMap {
                    "\($0.type.displayText ?? ""): \($0.value?.text ?? "")"
                } ?? []
                message += "\n" + fields.joined(separator: "\n")
                
                UIAlertController.showInfoAlert(title, message: message, presenter: presenter, completion: nil)
                
            } else {
                self?.didFinish()
            }
        }
        presentViewController(scanner)
    }
}

extension SBSDKCheckMagneticInkStripScanningStatus {
    var stringValue: String {
        switch self {
        case .success:
            return "Success"
        case .errorNothingFound:
            return "ErrorNothingFound"
        case .incompleteValidation:
            return "Incomplete"
        @unknown default:
            return "\(self.rawValue)"
        }
    }
}
