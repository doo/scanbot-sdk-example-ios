//
//  TextPatternLocalizationUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 05.02.25.
//

import UIKit
import ScanbotSDK

class TextPatternLocalizationUI2ViewController: UIViewController {
    
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
        
        // Retrieve the instance of the localization from the configuration object.
        let localization = configuration.localization
        
        // Configure the strings.
        // e.g
        localization.topUserGuidance = NSLocalizedString("top.user.guidance", comment: "")
        localization.cameraPermissionCloseButton = NSLocalizedString("camera.permission.close", comment: "")
        
        // Present the view controller modally.
        do {
            let result = try await SBSDKUI2TextPatternScannerViewController.present(on: self,
                                                                                    configuration: configuration)
            // Handle the result.
            print(result.rawText)
            print(result.confidence)
            result.wordBoxes.forEach { wordBox in
                print(wordBox.text)
                print(wordBox.recognitionConfidence)
                print(wordBox.boundingRect)
            }
            result.symbolBoxes.forEach { symbolBox in
                print(symbolBox.symbol)
                print(symbolBox.recognitionConfidence)
                print(symbolBox.boundingRect)
            }
        }
        catch SBSDKError.operationCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } catch {
            // Any other error
            print("Error scanning Text Pattern: \(error.localizedDescription)")
        }
    }
}
