//
//  TopBarBarcodeUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 28.12.23.
//

import Foundation
import ScanbotSDK

class TopBarBarcodeUI2ViewController: UIViewController {
    
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
        
        // Set the top bar mode.
        configuration.topBar.mode = .gradient
        
        // Set the background color which will be used as a gradient.
        configuration.topBar.backgroundColor = SBSDKUI2Color(colorString: "#C8193C")
        
        // Set the status bar mode.
        configuration.topBar.statusBarMode = .light
        
        // Configure the cancel button.
        configuration.topBar.cancelButton.text = "Cancel"
        configuration.topBar.cancelButton.foreground.color = SBSDKUI2Color(colorString: "#FFFFFF")
        
        // Create and set an array of accepted barcode formats.
        configuration.scannerConfiguration.setBarcodeFormats(SBSDKBarcodeFormats.twod)
        
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
