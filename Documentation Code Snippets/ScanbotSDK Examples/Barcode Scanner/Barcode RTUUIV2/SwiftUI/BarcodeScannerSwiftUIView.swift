//
//  BarcodeScannerSwiftUIView.swift
//  ScanbotSDK Examples
//
//  Created by Daniil Voitenko on 10.04.24.
//

import SwiftUI
import ScanbotSDK

struct BarcodeScannerSwiftUIView: View {
    
    // A boolean state variable indicating whether the barcode scanner interface should be presented.
    @State var showScan: Bool = false
    
    // An instance of `SBSDKUI2BarcodeScannerScreenConfiguration` which contains the configuration settings for the barcode scanner.
    let configuration: SBSDKUI2BarcodeScannerScreenConfiguration = {
        
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
        
        return configuration
    }()
    
    // An optional error object representing any errors that may occur during the scanning process.
    @State var scanError: Error?
    
    // An optional `SBSDKUI2BarcodeScannerUIResult` object containing the result of the scanning process.
    @State var scannerResult: SBSDKUI2BarcodeScannerUIResult?
    
    var body: some View {
        if let scannerResult = self.scannerResult {
            // Process and show the results here.

        } else if let error = self.scanError {
            // Show error view here.

        } else {
            // Show the scanner, pass the configuration and the button and error handlers.
            SBSDKUI2BarcodeScannerView(configuration: configuration, 
                                       onSubmit: { result in scannerResult = result }, 
                                       onCancel: { /* Dismiss your view here. */ }, 
                                       onError: { error in scanError = error })
            .ignoresSafeArea()
        }
    }
}

#Preview {
    BarcodeScannerSwiftUIView()
}
