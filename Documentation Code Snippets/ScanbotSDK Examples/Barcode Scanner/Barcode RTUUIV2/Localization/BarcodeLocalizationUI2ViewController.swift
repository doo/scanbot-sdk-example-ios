//
//  BarcodeLocalizationUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Sebastian Husche on 14.05.24.
//
import Foundation
import ScanbotSDK

class BarcodeLocalizationUI2ViewController: UIViewController {
    
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
        
        // Retrieve the instance of the localization from the configuration object.
        let localization = configuration.localization
        
        // Configure the strings.
        localization.barcodeInfoMappingErrorStateCancelButton = NSLocalizedString("barcode.infomapping.cancel", comment: "")
        localization.cameraPermissionCloseButton = NSLocalizedString("camera.permission.close", comment: "")
        
        // Set the localization in the barcode scanner configuration object.
        configuration.localization = localization
        
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
