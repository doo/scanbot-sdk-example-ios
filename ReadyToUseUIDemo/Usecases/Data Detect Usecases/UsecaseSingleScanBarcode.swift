//
//  UsecaseSingleScanBarcode.swift
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 22.12.23.
//  Copyright © 2023 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class UsecaseSingleScanBarcode: Usecase {
    
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        
        let configuration = SBSDKUI2BarcodeScannerConfiguration()
        configuration.userGuidance.title.text = "Please align the QR-/Barcode in the frame above to scan it."
        
        let scanner = SBSDKUI2BarcodeScannerViewController.create(with: configuration) { controller, cancelled, error, result in
            
            controller.presentingViewController?.dismiss(animated: true)
            
            if let result = result, !result.items.isEmpty {
                // Show results here.
                self.showResult(presenter, result: result)
            }
        }
        
        presentViewController(scanner)
    }
    
    func showResult(_ presenter: UIViewController, result: SBSDKUI2BarcodeScannerResult) {
        let message = result.items.map { $0.text + " (\($0.count))"  }.joined(separator: "\n")
        let alert = UIAlertController(title: "\(result.items.count) barcodes found", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default))
        presenter.present(alert, animated: true)
    }
}
