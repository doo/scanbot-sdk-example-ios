//
//  FindAndPickBarcodeScannerUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct FindAndPickBarcodeScannerUI2SwiftUIView: View {
    
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

        // Initialize the find and pick usecase.
        let usecase = SBSDKUI2FindAndPickScanningMode()

        // Configure AR Overlay.
        usecase.arOverlay.visible = true

        // Enable/Disable the automatic selection.
        usecase.arOverlay.automaticSelectionEnabled = false

        // Enable/Disable the swipe to delete.
        usecase.sheetContent.swipeToDelete.enabled = true

        // Enable/Disable allow partial scan.
        usecase.allowPartialScan = true

        // Set the expected barcodes.
        usecase.expectedBarcodes = [
            SBSDKUI2ExpectedBarcode(barcodeValue: "123456",
                                    title: nil,
                                    image: "Image_URL",
                                    count: 4),
            SBSDKUI2ExpectedBarcode(barcodeValue: "SCANBOT",
                                    title: nil,
                                    image: "Image_URL",
                                    count: 3)
        ]

        // Set the configured usecase.
        configuration.useCase = usecase
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
    FindAndPickBarcodeScannerUI2SwiftUIView()
}
