//
//  MRZCustomConfigurationUI2ViewController.swift
//  ScanbotSDK Examples
//

import UIKit
import ScanbotSDK

class MRZCustomConfigurationUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        Task {
            await startScanning()
        }
    }
    
    func startScanning() async {
        
        // An instance of `SBSDKUI2MRZScannerScreenConfiguration` which contains the configuration settings for the MRZ scanner.
        let configuration = SBSDKUI2MRZScannerScreenConfiguration()
        
        do {
            let scannedMRZ = try await SBSDKUI2MRZScannerViewController.present(on: self, configuration: configuration)
            
            // Process and show the scanned MRZ here.
            
            // Cast the resulting generic document to the MRZ model using the `wrap` method.
            if let model = scannedMRZ.mrzDocument?.wrap() as? SBSDKDocumentsModelMRZ {
                
                // Retrieve the values.
                // e.g
                if let birthDate = model.birthDate?.value {
                    print("Birth date: \(birthDate.text), Confidence: \(birthDate.confidence)")
                }
                if let nationality = model.nationality?.value {
                    print("Nationality: \(nationality.text), Confidence: \(nationality.confidence)")
                }
            }
            
        } catch SBSDKError.operationCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } catch {
            // Show error view here.
            print("Scan error: \(error.localizedDescription)")
        }
    }
}
