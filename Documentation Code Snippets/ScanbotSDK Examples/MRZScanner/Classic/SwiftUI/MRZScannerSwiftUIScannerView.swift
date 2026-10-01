//
//  MRZScannerSwiftUIScannerView.swift
//  ScanbotSDK Examples
//
//  Pure-SwiftUI counterpart of `MRZScannerViewController`.
//

import SwiftUI
import ScanbotSDK

struct MRZScannerSwiftUIScannerView: View {

    // The scanner view model backing the `SBSDKScannerView` below. It owns the camera session, the
    // scanner configuration and the frame-engine state, and is the SwiftUI equivalent of the
    // Classic UI `SBSDKMRZScannerViewController`.
    @State private var viewModel: SBSDKMRZScannerViewModel = {

        // Create the default configuration.
        let configuration = SBSDKMRZScannerConfiguration()

        // Customize the configuration as needed.

        // Enable the document detection.
        configuration.enableDetection = true

        // Customize the frame accumulation configuration as needed.
        configuration.frameAccumulationConfiguration.maximumNumberOfAccumulatedFrames = 3
        configuration.frameAccumulationConfiguration.minimumNumberOfRequiredFramesWithEqualScanningResult = 2

        // Whether to accept or reject incomplete MRZ results.
        configuration.incompleteResultHandling = .accept

        return try! SBSDKMRZScannerViewModel(scannerConfiguration: configuration)
    }()

    var body: some View {

        // Embed the `SBSDKMRZScannerViewModel`-driven camera/detection UI.
        SBSDKScannerView(model: viewModel)
            // Subscribe to the frame engine's result/failure events. This replaces
            // `SBSDKMRZScannerViewControllerDelegate`.
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
                    print("Error scanning MRZ: \(error.localizedDescription)")
                }
            }
    }
}

#Preview {
    MRZScannerSwiftUIScannerView()
}
