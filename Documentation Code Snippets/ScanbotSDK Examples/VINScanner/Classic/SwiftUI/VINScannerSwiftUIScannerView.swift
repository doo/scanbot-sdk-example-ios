//
//  VINScannerSwiftUIScannerView.swift
//  ScanbotSDK Examples
//
//  Pure-SwiftUI counterpart of `VINScannerViewController`.
//

import SwiftUI
import ScanbotSDK

struct VINScannerSwiftUIScannerView: View {

    // The scanner view model backing the `SBSDKScannerView` below. It owns the camera session, the
    // scanner configuration and the frame-engine state, and is the SwiftUI equivalent of the
    // Classic UI `SBSDKVINScannerViewController`.
    @State private var viewModel: SBSDKVINScannerViewModel = {

        // Create an instance of the configuration for vehicle identification numbers.
        let configuration = SBSDKVINScannerConfiguration()

        // Enable extraction of VIN from barcode.
        configuration.extractVINFromBarcode = true

        return try! SBSDKVINScannerViewModel(scannerConfiguration: configuration)
    }()

    var body: some View {

        // Embed the `SBSDKVINScannerViewModel`-driven camera/detection UI.
        SBSDKScannerView(model: viewModel)
            // Subscribe to the frame engine's result/failure events. This replaces
            // `SBSDKVINScannerViewControllerDelegate`.
            .onReceive(viewModel.frameEngine.events) { event in
                switch event {
                case .failure(let error):
                    // Handle the error.
                    print("Error scanning VIN: \(error.localizedDescription)")

                case .validResult(let result, _):
                    // Process the result.

                    // If `extractVINFromBarcode` from the configuration is set to `true`, you must check the barcode result first.
                    if result.barcodeResult.status == .success && !result.barcodeResult.extractedVIN.isEmpty {
                        print(result.barcodeResult.extractedVIN)

                    // else check the text result.
                    } else if result.textResult.validationSuccessful && !result.textResult.rawText.isEmpty {
                        print(result.textResult.rawText)
                    }

                case .everyFrame:
                    // Fired for every processed frame, regardless of validity; nothing to do here.
                    break
                }
            }
    }
}

#Preview {
    VINScannerSwiftUIScannerView()
}
