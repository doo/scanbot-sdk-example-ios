//
//  SingleBarcodeScannerUI2SwiftViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 19.12.23.
//

import Foundation
import ScanbotSDK

class SingleBarcodeScannerUI2SwiftViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2BarcodeScannerConfiguration()
        
        // Initialize the single scan usecase.
        let singleUsecase = SBSDKUI2SingleScanningMode()
        
        // Enable and configure the confirmation sheet.
        singleUsecase.confirmationSheetEnabled = true
        singleUsecase.sheetColor = SBSDKUI2Color(colorString: "#FFFFFF")
        
        // Hide/unhide the barcode image.
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
        configuration.recognizerConfiguration.barcodeFormats = SBSDKUI2BarcodeFormat.twoDFormats
        
        // Present the recognizer view controller modally on this view controller.
        SBSDKUI2BarcodeScannerViewController.present(on: self,
                                                     configuration: configuration) { controller, cancelled, error, result in
            
            // Completion handler to process the result.
            // The `cancelled` parameter indicates if the cancel button was tapped.
            
            controller.presentingViewController?.dismiss(animated: true)
        }
    }
}
