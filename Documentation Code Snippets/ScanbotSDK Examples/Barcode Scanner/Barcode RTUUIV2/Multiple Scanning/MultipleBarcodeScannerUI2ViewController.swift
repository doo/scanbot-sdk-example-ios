//
//  MultipleBarcodeScannerUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 19.12.23.
//

import Foundation
import ScanbotSDK

class MultipleBarcodeScannerUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2BarcodeScannerConfiguration()
        
        // Initialize the multi scan usecase.
        let multiUsecase = SBSDKUI2MultipleScanningMode()
        
        // Set the counting repeat delay.
        multiUsecase.countingRepeatDelay = 1000
        
        // Set the counting mode.
        multiUsecase.mode = .counting
        
        // Set the sheet mode of the barcodes preview.
        multiUsecase.sheet.mode = .collapsedSheet
        
        // Set the height of the collapsed sheet.
        multiUsecase.sheet.collapsedVisibleHeight = .large
        
        // Enable manual count change.
        multiUsecase.sheetContent.manualCountChangeEnabled = true
        
        // Configure the submit button.
        multiUsecase.sheetContent.submitButton.text = "Submit"
        multiUsecase.sheetContent.submitButton.foreground.color = SBSDKUI2Color(colorString: "#000000")
        
        // Set the configured usecase.
        configuration.useCase = multiUsecase
        
        // Create and set an array of accepted barcode formats.
        configuration.recognizerConfiguration.barcodeFormats = SBSDKBarcodeFormats.twod
        
        // Present the view controller modally.
        SBSDKUI2BarcodeScannerViewController.present(on: self,
                                                     configuration: configuration) { controller, cancelled, error, result in
            
            // Completion handler to process the result.
            // The `cancelled` parameter indicates if the cancel button was tapped.
            
            controller.presentingViewController?.dismiss(animated: true)
        }
    }
}
