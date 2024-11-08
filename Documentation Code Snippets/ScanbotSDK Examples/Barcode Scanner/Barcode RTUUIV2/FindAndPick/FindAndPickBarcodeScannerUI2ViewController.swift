//
//  FindAndPickBarcodeScannerUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 25.03.24.
//

import UIKit
import ScanbotSDK

class FindAndPickBarcodeScannerUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2BarcodeScannerConfiguration()
        
        // Initialize the find and pick usecase.
        let usecase = SBSDKUI2FindAndPickScanningMode()
        
        // Configure AR Overlay.
        usecase.arOverlay.visible = true
        
        // Enable/Disable the automatic selection.
        usecase.arOverlay.automaticSelectionEnabled = false
        
        // Enable/Disable the swipe to delete.
        usecase.sheetContent.swipeToDelete.enabled = true
        
        // Enable/Disable allow partial scan.
        usecase.allowPartialScan = true
        
        // Set the expected barcodes.
        usecase.expectedBarcodes = [
            SBSDKUI2ExpectedBarcode(barcodeValue: "123456",
                                    title: nil,
                                    image: "Image_URL",
                                    count: 4),
            SBSDKUI2ExpectedBarcode(barcodeValue: "SCANBOT",
                                    title: nil,
                                    image: "Image_URL",
                                    count: 3)
        ]
        
        // Set the configured usecase.
        configuration.useCase = usecase
        
        // Present the recognizer view controller modally on this view controller.
        SBSDKUI2BarcodeScannerViewController.present(on: self,
                                                     configuration: configuration) { controller, cancelled, error, result in
            
            // Completion handler to process the result.
            // The `cancelled` parameter indicates if the cancel button was tapped.
            
            controller.presentingViewController?.dismiss(animated: true)
        }
    }
}
