//
//  TinyBarcodeScannerUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct TinyBarcodeScannerUI2SwiftUIView: View {
    
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

        // Enable locking the focus at the minimum possible distance.
        configuration.cameraConfiguration.minFocusDistanceLock = true
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
    TinyBarcodeScannerUI2SwiftUIView()
}
