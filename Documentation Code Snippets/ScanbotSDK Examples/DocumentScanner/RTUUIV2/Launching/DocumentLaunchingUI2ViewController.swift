//
//  DocumentLaunchingUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 19.08.24.
//

import Foundation
import ScanbotSDK

class DocumentLaunchingUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2DocumentScanningFlow()
        
        // Present the view controller modally.
        SBSDKUI2DocumentScannerController.present(on: self,
                                                  configuration: configuration) { document in
            
            // Completion handler to process the result.
            
            if let document {
                // Handle the document.
                
            } else {
                // Indicates that the cancel button was tapped.
            }
        }
    }
}
