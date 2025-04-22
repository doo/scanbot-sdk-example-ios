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
        self.startScanning()
    }
    
    func startScanning() {
        
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
        SBSDKUI2BarcodeScannerViewController.present(on: self,
                                                     configuration: configuration) { controller, cancelled, error, result in
            
            // Completion handler to process the result.
            // The `cancelled` parameter indicates if the cancel button was tapped.
            
            controller.presentingViewController?.dismiss(animated: true)
        }
    }
}
