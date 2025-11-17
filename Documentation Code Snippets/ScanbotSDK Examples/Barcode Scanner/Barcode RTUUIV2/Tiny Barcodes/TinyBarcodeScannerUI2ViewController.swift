//
//  TinyBarcodeScannerUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 17.07.25.
//

import Foundation
import ScanbotSDK

class TinyBarcodeScannerUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2BarcodeScannerScreenConfiguration()
        
        // Enable locking the focus at the minimum possible distance.
        configuration.cameraConfiguration.minFocusDistanceLock = true
        
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
