//
//  SingleBarcodeScannerUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct SingleBarcodeScannerUI2SwiftUIView: View {
    
    @State private var configuration = Self.makeConfiguration()
    @State private var scanError: Error?
    @State private var scannerResult: SBSDKUI2BarcodeScannerUIResult?
    
    var body: some View {
        
        if let scannerResult {
            Text("Barcodes scanned: \(scannerResult.items.count)")

        } else if let scanError {
            Text("Scan error: \(scanError.localizedDescription)")

        } else {
            
            // Create and present the scanner view.
            SBSDKUI2BarcodeScannerView(configuration: configuration,
                                                                 completion: { result, error in
                scannerResult = result
                scanError = error
                if let result {
                    handle(result: result)
                }
                if let error {
                    if case SBSDKError.operationCanceled = error {
                        print("The operation was cancelled before completion or by the user")
                    } else {
                        // Any other error
                        print("Error scanning barcode: \(error.localizedDescription)")
                    }
                }
            })
                    .ignoresSafeArea()

        }
    }
    
    static func makeConfiguration() -> SBSDKUI2BarcodeScannerScreenConfiguration {
        
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
    }
    
    func handle(result: SBSDKUI2BarcodeScannerUIResult) {
        
        // Handle the result.
        result.items.forEach { barcodeItem in
            // e.g
            print(barcodeItem.count)
            print(barcodeItem.barcode.format.name)
            print(barcodeItem.barcode.text)
            print(barcodeItem.barcode.textWithExtension)
            // Check out other available properties in `SBSDKBarcodeItem`.
        }
        print(result.selectedZoomFactor)
    }
}

#Preview {
    SingleBarcodeScannerUI2SwiftUIView()
}
