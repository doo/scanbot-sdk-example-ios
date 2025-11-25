//
//  TextPatternFinderOverlayUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 11.08.25.
//

import UIKit
import ScanbotSDK

class TextPatternFinderOverlayUI2ViewController: UIViewController {
    
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
        
        // Configure the view finder.
        // Set the style for the view finder.
        // Choose between cornered or stroked style.
        // For default stroked style.
        configuration.viewFinder.style = .finderStrokedStyle()
        // For default cornered style.
        configuration.viewFinder.style = .finderCorneredStyle()
        // You can also set each style's stroke width, stroke color or corner radius.
        // e.g
        configuration.viewFinder.style = SBSDKUI2FinderCorneredStyle(strokeWidth: 3.0)
        
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
