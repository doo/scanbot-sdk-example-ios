//
//  VINActionBarUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 05.02.25.
//

import UIKit
import ScanbotSDK

class VINActionBarUI2ViewController: UIViewController {
    
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
        
        // Retrieve the instance of the action bar from the configuration object.
        let actionBar = configuration.actionBar
        
        // Show the torch button.
        actionBar.torchButton.visible = true
        
        // Configure the inactive state of the torch button.
        actionBar.torchButton.backgroundColor = SBSDKUI2Color(colorString: "#7A000000")
        actionBar.torchButton.foregroundColor = SBSDKUI2Color(colorString: "#FFFFFF")
        
        // Configure the active state of the torch button.
        actionBar.torchButton.activeBackgroundColor = SBSDKUI2Color(colorString: "#FFCE5C")
        actionBar.torchButton.activeForegroundColor = SBSDKUI2Color(colorString: "#000000")
        
        // Show the zoom button.
        actionBar.zoomButton.visible = true
        
        // Configure the zoom button.
        actionBar.zoomButton.backgroundColor = SBSDKUI2Color(colorString: "#7A000000")
        actionBar.zoomButton.foregroundColor = SBSDKUI2Color(colorString: "#FFFFFF")
        
        // Show the flip camera button.
        actionBar.flipCameraButton.visible = true
        
        // Configure the flip camera button.
        actionBar.flipCameraButton.backgroundColor = SBSDKUI2Color(colorString: "#7A000000")
        actionBar.flipCameraButton.foregroundColor = SBSDKUI2Color(colorString: "#FFFFFF")
        
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
