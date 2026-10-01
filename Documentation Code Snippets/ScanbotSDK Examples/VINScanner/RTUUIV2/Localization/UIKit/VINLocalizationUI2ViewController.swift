//
//  VINLocalizationUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 05.02.25.
//

import UIKit
import ScanbotSDK

class VINLocalizationUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        Task {
            await startScanning()
        }
    }
    
    func startScanning() async {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2VINScannerScreenConfiguration()
        
        // Retrieve the instance of the localization from the configuration object.
        let localization = configuration.localization
        
        // Configure the strings.
        // e.g
        localization.topUserGuidance = NSLocalizedString("top.user.guidance", comment: "")
        localization.cameraPermissionCloseButton = NSLocalizedString("camera.permission.close", comment: "")
        
        // Present the view controller modally.
        do {
            let result = try await SBSDKUI2VINScannerViewController.present(on: self, configuration: configuration)
            
            // Handle the result.
            print(result.textResult.rawText)
            print(result.textResult.confidence)
            print(result.textResult.validationSuccessful)
            
            // If expecting VIN from barcode.
            print(result.barcodeResult.extractedVIN)
            print(result.barcodeResult.status)
            print(result.barcodeResult.rectangle)
        
        } catch SBSDKError.operationCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } catch {
            // Any other error
            print("Error scanning VIN: \(error.localizedDescription)")
        }
    }
}
