//
//  UsecaseFindAndPickScanBarcode.swift
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 25.03.24.
//  Copyright © 2024 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class UsecaseFindAndPickScanBarcode: Usecase {
    
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        
        let configuration = SBSDKUI2BarcodeScannerConfiguration()
        configuration.userGuidance.title.text = "Please align the QR-/Barcode in the frame above to scan it."
        
        let usecase = SBSDKUI2FindAndPickScanningMode()
        usecase.arOverlay.automaticSelectionEnabled = false
        usecase.arOverlay.visible = true
        usecase.allowPartialScan = true
        
        usecase.expectedBarcodes = [
            SBSDKUI2ExpectedBarcode(barcodeValue: "ScanbotSDK", title: "ScanbotSDK", image: "https://avatars.githubusercontent.com/u/1454920?s=280&v=4", count: 4),
            SBSDKUI2ExpectedBarcode(barcodeValue: "Hello world!", title: "Hello world!", image: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/74/HelloWorld_in_black_and_white.svg/240px-HelloWorld_in_black_and_white.svg.png", count: 3)
        ]
        
        configuration.useCase = usecase
        
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
