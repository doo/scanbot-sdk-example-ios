//
//  SingleBarcodeScannerUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 19.12.23.
//

import Foundation
import ScanbotSDK

class SingleBarcodeScannerUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2BarcodeScannerScreenConfiguration()
        
        // Initialize the single scan usecase.
        let singleUsecase = SBSDKUI2SingleScanningMode()
        
        // Enable and configure the confirmation sheet.
        singleUsecase.confirmationSheetEnabled = true
        singleUsecase.sheetColor = SBSDKUI2Color(colorString: "#FFFFFF")
        
        // Show the barcode image.
        singleUsecase.barcodeImageVisible = true
        
        // Configure the barcode title of the confirmation sheet.
        singleUsecase.barcodeTitle.visible = true
        singleUsecase.barcodeTitle.color = SBSDKUI2Color(colorString: "#000000")
        
        // Configure the barcode subtitle of the confirmation sheet.
        singleUsecase.barcodeSubtitle.visible = true
        singleUsecase.barcodeSubtitle.color = SBSDKUI2Color(colorString: "#000000")
        
        // Configure the cancel button of the confirmation sheet.
        singleUsecase.cancelButton.text = "Close"
        singleUsecase.cancelButton.foreground.color = SBSDKUI2Color(colorString: "#C8193C")
        singleUsecase.cancelButton.background.fillColor = SBSDKUI2Color(colorString: "#00000000")
        
        // Configure the submit button of the confirmation sheet.
        singleUsecase.submitButton.text = "Submit"
        singleUsecase.submitButton.foreground.color = SBSDKUI2Color(colorString: "#FFFFFF")
        singleUsecase.submitButton.background.fillColor = SBSDKUI2Color(colorString: "#C8193C")
        
        // Set the configured usecase.
        configuration.useCase = singleUsecase
        
        // Create and set an array of accepted barcode formats.
        configuration.scannerConfiguration.setBarcodeFormats(SBSDKBarcodeFormats.twod)
        
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
