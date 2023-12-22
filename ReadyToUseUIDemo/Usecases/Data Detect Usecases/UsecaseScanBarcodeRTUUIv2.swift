//
//  UsecaseScanBarcodeRTUUIv2.swift
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 22.12.23.
//  Copyright © 2023 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class UsecaseScanBarcodeRTUUIv2: Usecase, SBSDKUI2BarcodeItemMapper {
    
    
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        
        let configuration = SBSDKUI2BarcodeScannerConfiguration.defaultConfiguration
        
        // Configure multi scanning...
        let multiUsecase = SBSDKUI2MultipleScanningMode()
        configuration.useCase = multiUsecase
        
        // ... or configure single scanning
        //let singleUsesecase = SBSDKUI2SingleScanningMode()
        //configuration.useCase = singleUsesecase
        
        // Configure AR overlay
        configuration.arOverlay.visible = true
        configuration.arOverlay.automaticSelectionEnabled = false
        
        // Set the barcode item mapper
        //configuration.barcodeInfoMapping.barcodeItemMapper = self
        
        let scanner = SBSDKUI2BarcodeScannerViewController.create(with: configuration) { controller, cancelled, error, result in
            
            controller.presentingViewController?.dismiss(animated: true)
            
            if let result = result, !result.items.isEmpty {
                // Show results here.
                self.showResult(presenter, result: result)
            }
        }
        
        presentViewController(scanner)
    }
    
    func mapBarcodeItem(item: SBSDKUI2BarcodeItem, onResult: @escaping (SBSDKUI2BarcodeMappedData) -> Void, onError: @escaping (SBSDKUI2BarcodeItemErrorState) -> Void) {
        
        // Load your mapping data here async...
        let mappedData = SBSDKUI2BarcodeMappedData(title: "Mapped title", 
                                                   subtitle: "Mapped subtitle", 
                                                   barcodeImage: "URL to image")
        // and call the onResult block...
        onResult(mappedData)
        
        // or the onError block
        //onError(.defaultConfiguration)
    }
    
    func showResult(_ presenter: UIViewController, result: SBSDKUI2BarcodeScannerResult) {
        let message = result.items.map { $0.text + " (\($0.count))"  }.joined(separator: "\n")
        let alert = UIAlertController(title: "\(result.items.count) barcodes found", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default))
        presenter.present(alert, animated: true)
    }
}
