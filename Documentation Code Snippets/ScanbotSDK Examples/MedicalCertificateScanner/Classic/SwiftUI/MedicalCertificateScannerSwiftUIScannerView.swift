//
//  MedicalCertificateScannerSwiftUIScannerView.swift
//  ScanbotSDK Examples
//
//  Pure-SwiftUI counterpart of `MedicalCertificateScannerViewController`.
//

import SwiftUI
import ScanbotSDK

struct MedicalCertificateScannerSwiftUIScannerView: View {

    // The scanner view model backing the `SBSDKScannerView` below. It owns the camera session, the
    // scanner configuration and the frame-engine state, and is the SwiftUI equivalent of the
    // Classic UI `SBSDKMedicalCertificateScannerViewController`.
    @State private var viewModel: SBSDKMedicalCertificateScannerViewModel = {

        // Create an instance of `SBSDKMedicalCertificateScanningParameters` with default values.
        let scanningParameters = SBSDKMedicalCertificateScanningParameters()

        // Enable the medical certificate image extraction.
        scanningParameters.extractCroppedImage = true

        // Customize the parameters as needed.
        scanningParameters.shouldCropDocument = true
        scanningParameters.recognizePatientInfoBox = true
        scanningParameters.recognizeBarcode = true
        scanningParameters.preprocessInput = false

        return try! SBSDKMedicalCertificateScannerViewModel(scannerConfiguration: scanningParameters)
    }()

    var body: some View {

        // Embed the `SBSDKMedicalCertificateScannerViewModel`-driven camera/detection UI.
        SBSDKScannerView(model: viewModel)
            // Subscribe to the frame engine's result/failure events. This replaces
            // `SBSDKMedicalCertificateScannerViewControllerDelegate`.
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
                    print("Error scanning Medical certificate: \(error.localizedDescription)")
                }
            }
    }
}

#Preview {
    MedicalCertificateScannerSwiftUIScannerView()
}
