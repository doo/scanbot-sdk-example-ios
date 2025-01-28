//
//  MRZLaunchingUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 20.01.25.
//

import UIKit
import ScanbotSDK

class MRZLaunchingUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2MRZScannerScreenConfiguration()
        
        // Present the view controller modally.
        SBSDKUI2MRZScannerViewController.present(on: self,
                                                 configuration: configuration) { result in
            if let result {
                // Handle the result.
                
            } else {
                // Indicates that the cancel button was tapped.
            }
        }
    }
}
