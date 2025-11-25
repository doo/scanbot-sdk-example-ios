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
        
        Task {
            await self.startScanning()
        }
    }
    
    func startScanning() async {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2DocumentScanningFlow()
        
        do {
            let result = try await SBSDKUI2DocumentScannerController.present(on: self, configuration: configuration)
        }
        catch SBSDKError.operationCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } catch {
            // Any other error
            print("Error scanning document: \(error.localizedDescription)")
        }
    }
}
