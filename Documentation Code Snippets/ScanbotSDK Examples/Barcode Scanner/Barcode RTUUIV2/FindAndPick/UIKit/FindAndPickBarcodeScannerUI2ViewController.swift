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
        Task {
            await self.startScanning()
        }
    }
    
    func startScanning() async {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2BarcodeScannerScreenConfiguration()
        
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
        
        // Present the view controller modally.
        do {
            let result = try await SBSDKUI2BarcodeScannerViewController.present(on: self, configuration: configuration)
            
            // Handle the result.
            result.items.forEach { barcodeItem in
                // e.g
                print(barcodeItem.count)
                print(barcodeItem.barcode.format.name)
                print(barcodeItem.barcode.text)
                print(barcodeItem.barcode.textWithExtension)
                // Check out other available properties in `SBSDKBarcodeItem`.
            }
            print(result.selectedZoomFactor)
        
        } catch SBSDKError.operationCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } catch {
            // Any other error
            print("Error scanning barcode: \(error.localizedDescription)")
        }
    }
}
