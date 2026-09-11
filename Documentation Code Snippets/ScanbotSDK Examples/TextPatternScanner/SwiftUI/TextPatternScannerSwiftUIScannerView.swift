//
//  TextPatternScannerSwiftUIScannerView.swift
//  ScanbotSDK Examples
//
//  Pure-SwiftUI counterpart of `TextPatternScannerViewController`.
//

import SwiftUI
import ScanbotSDK

struct TextPatternScannerSwiftUIScannerView: View {

    // The scanner view model backing the `SBSDKScannerView` below. It owns the camera session, the
    // scanner configuration and the frame-engine state, and is the SwiftUI equivalent of the
    // Classic UI `SBSDKTextPatternScannerViewController`.
    @State private var viewModel: SBSDKTextPatternScannerViewModel = {

        // Create the default `SBSDKTextPatternScannerConfiguration` object.
        let configuration = SBSDKTextPatternScannerConfiguration()
        return try! SBSDKTextPatternScannerViewModel(scannerConfiguration: configuration)
    }()

    var body: some View {

        // Embed the `SBSDKTextPatternScannerViewModel`-driven camera/detection UI.
        SBSDKScannerView(model: viewModel)
            // Subscribe to the frame engine's result/failure events. This replaces
            // `SBSDKTextPatternScannerViewControllerDelegate`.
            .onReceive(viewModel.frameEngine.events) { event in
                switch event {
                case .validResult(let result, _):
                    // Process the scanned result.
                    break

                case .everyFrame:
                    // Fired for every processed frame, regardless of validity; nothing to do here.
                    break

                case .failure(let error):
                    // Handle the error.
                    print("Error scanning text pattern: \(error.localizedDescription)")
                }
            }
    }
}

#Preview {
    TextPatternScannerSwiftUIScannerView()
}
