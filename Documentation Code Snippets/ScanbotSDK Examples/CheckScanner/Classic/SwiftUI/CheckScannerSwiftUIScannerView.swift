//
//  CheckScannerSwiftUIScannerView.swift
//  ScanbotSDK Examples
//
//  Pure-SwiftUI counterpart of `CheckScannerViewController`.
//

import SwiftUI
import ScanbotSDK

struct CheckScannerSwiftUIScannerView: View {

    // The label to present the scanning status updates.
    @State private var statusText: String = ""

    // The scanner view model backing the `SBSDKScannerView` below. It owns the camera session, the
    // scanner configuration and the frame-engine state, and is the SwiftUI equivalent of the
    // Classic UI `SBSDKCheckScannerViewController`.
    @State private var viewModel: SBSDKCheckScannerViewModel = {

        // Create a configuration with `detectAndCropDocument` to extract the check image.
        let configuration = SBSDKCheckScannerConfiguration(documentDetectionMode: .detectAndCropDocument)

        let model = try! SBSDKCheckScannerViewModel(scannerConfiguration: configuration)

        // Customize the default accepted check types as needed.
        // For this example we will use the following types of check.
        model.configuration.acceptedCheckTypes = [.usaCheck, .uaeCheck, .fraCheck, .isrCheck,
                                                  .kwtCheck, .ausCheck, .indCheck, .canCheck]
        return model
    }()

    var body: some View {
        ZStack(alignment: .top) {

            // Embed the `SBSDKCheckScannerViewModel`-driven camera/detection UI.
            SBSDKScannerView(model: viewModel)

            Text(statusText)
                .padding()
                .background(.black.opacity(0.6))
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding()
        }
        // Subscribe to the frame engine's result/failure events. This replaces
        // `SBSDKCheckScannerViewControllerDelegate`.
        .onReceive(viewModel.frameEngine.events) { event in
            switch event {
            case .capturedResult(let result, _), .validResult(let result, _):
                // Process the scanned result.

                // Get the cropped image.
                let croppedImage = try? result.croppedImage?.toUIImage()

            case .everyFrame:
                // Fired for every processed frame, regardless of validity; nothing to do here.
                break

            case .failure(let error):
                // Handle the error.
                print("Error scanning check: \(error.localizedDescription)")
            }
        }
        // Subscribe to state changes, mirroring the `didChangeState` delegate callback.
        .onReceive(viewModel.frameEngine.publisher(for: \.state, options: [.initial, .new])) { state in

            // Update status label according to status
            switch state {
            case .searching:
                statusText = "Looking for the check"
            case .capturing:
                statusText = "Capturing the check"
            case .energySaving:
                statusText = "Energy saving mode"
            case .paused:
                statusText = "Recognition paused"
            @unknown default:
                fatalError()
            }
        }
    }
}

#Preview {
    CheckScannerSwiftUIScannerView()
}
