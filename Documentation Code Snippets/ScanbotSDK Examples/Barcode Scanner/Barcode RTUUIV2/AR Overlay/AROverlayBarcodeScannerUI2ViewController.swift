//
//  AROverlayBarcodeScannerUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 19.12.23.
//

import Foundation
import ScanbotSDK

class AROverlayBarcodeScannerUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2BarcodeScannerScreenConfiguration()
        
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
        configuration.scannerConfiguration.setBarcodeFormats(SBSDKBarcodeFormats.twod)
        
        // Present the view controller modally.
        SBSDKUI2BarcodeScannerViewController.present(on: self,
                                                     configuration: configuration) { controller, result, error in
            
            // Completion handler to process the result.
            
            if let result {
                
                // Process the result.
                
            } else if let error {
                
                // Handle the error.
                print("Error scanning barcode: \(error.localizedDescription)")
            }
        }
    }
}
