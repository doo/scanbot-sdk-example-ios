//
//  BarcodeViewFinderUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct BarcodeViewFinderUI2SwiftUIView: View {
    
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

        // Set visibility for the view finder.
        configuration.viewFinder.visible = true

        // Create the instance of the style, either `SBSDKUI2FinderCorneredStyle` or `SBSDKUI2FinderStrokedStyle`.
        let style = SBSDKUI2FinderCorneredStyle(strokeColor: SBSDKUI2Color(colorString: "#FFFFFFFF"),
                                                strokeWidth: 3.0,
                                                cornerRadius: 10.0)

        // Set the configured style.
        configuration.viewFinder.style = style

        // Set the desired aspect ratio of the view finder.
        configuration.viewFinder.aspectRatio = SBSDKAspectRatio(width: 1.0, height: 1.0)

        // Set the overlay color.
        configuration.viewFinder.overlayColor = SBSDKUI2Color(colorString: "#26000000")

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
    BarcodeViewFinderUI2SwiftUIView()
}
