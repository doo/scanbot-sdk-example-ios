//
//  VINCustomConfigurationUI2ViewController.swift
//  ScanbotSDK Examples
//

import UIKit
import ScanbotSDK

class VINCustomConfigurationUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        Task {
            await startScanning()
        }
    }
    
    func startScanning() async {
        
        // An instance of `SBSDKUI2VINScannerScreenConfiguration` which contains the configuration settings for the VIN scanner.
        let configuration = SBSDKUI2VINScannerScreenConfiguration()
        
        do {
            let scannedVIN = try await SBSDKUI2VINScannerViewController.present(on: self, configuration: configuration)
            
            // Process and show the scanned VIN here.
            print("Scanned VIN Text: \(scannedVIN.textResult)")
            print("Scanned VIN Barcode Status: \(barcodeStatusString(scannedVIN.barcodeResult.status))")
            print("Barcode extracted VIN: \(scannedVIN.barcodeResult.extractedVIN)")
            
        } catch SBSDKError.operationCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } catch {
            // Show error view here.
            print("Scan error: \(error.localizedDescription)")
        }
    }
    
    func barcodeStatusString(_ status: SBSDKVINBarcodeExtractionStatus) -> String {
        switch status {
        case .success: return "Success"
        case .barcodeWithoutVin: return "Barcode without VIN"
        case .noBarcodeFound: return "No barcode found"
        case .barcodeExtractionDisabled: return "Barcode extraction disabled"
        default: return "Unknown status"
        }
    }
}
