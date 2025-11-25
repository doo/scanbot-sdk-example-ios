//
//  TextPatternLaunchingUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 05.02.25.
//

import UIKit
import ScanbotSDK

class TextPatternLaunchingUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        Task {
            await startScanning()
        }
    }
    
    func startScanning() async {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2TextPatternScannerScreenConfiguration()
        
        // Present the view controller modally.
        do {
            let result = try await SBSDKUI2TextPatternScannerViewController.present(on: self,
                                                                                    configuration: configuration)
            // Process the result as needed.
        
        } catch SBSDKError.operationCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } catch {
            // Any other error
            print("Error scanning Text Pattern: \(error.localizedDescription)")
        }
    }
}
