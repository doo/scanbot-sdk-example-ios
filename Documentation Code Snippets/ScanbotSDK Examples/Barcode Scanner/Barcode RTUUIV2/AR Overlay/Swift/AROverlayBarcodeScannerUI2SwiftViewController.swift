//
//  AROverlayBarcodeScannerUI2SwiftViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 19.12.23.
//

import Foundation
import ScanbotSDK

class AROverlayBarcodeScannerUI2SwiftViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2BarcodeScannerConfiguration()
        
        // Configure the usecase.
        let usecase = SBSDKUI2MultipleScanningMode()
        usecase.mode = .unique
        usecase.sheet.mode = .collapsedSheet
        usecase.sheet.collapsedVisibleHeight = .small
        
        // Configure AR Overlay.
        usecase.arOverlay.visible = true
        usecase.arOverlay.automaticSelectionEnabled = false
        
        // Set the configured usecase.
        configuration.useCase = usecase
        
        // Create and set an array of accepted barcode formats.
        configuration.recognizerConfiguration.barcodeFormats = SBSDKUI2BarcodeFormat.twoDFormats
        
        // Present the recognizer view controller modally on this view controller.
        SBSDKUI2BarcodeScannerViewController.present(on: self,
                                                     configuration: configuration) { controller, cancelled, error, result in
            
            // Completion handler to process the result.
            // The `cancelled` parameter indicates if the cancel button was tapped.
            
            controller.presentingViewController?.dismiss(animated: true)
        }
    }
}
