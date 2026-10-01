//
//  DocumentScannerSwiftUIScannerView.swift
//  ScanbotSDK Examples
//
//  Pure-SwiftUI counterpart of `DocumentScannerViewController`.
//

import SwiftUI
import ScanbotSDK

struct DocumentScannerSwiftUIScannerView: View {

    // The scanner view model backing the `SBSDKScannerView` below. It owns the camera session, the
    // scanner configuration and the frame-engine state, and is the SwiftUI equivalent of the
    // Classic UI `SBSDKDocumentScannerViewController`.
    // `try!` is safe here for example purposes; a real app should surface the thrown
    // `SBSDKError` (e.g. an invalid/missing license) instead of force-trying.
    @State private var viewModel = try! SBSDKDocumentScannerViewModel()

    // The last scanned result, shown as a simple text overlay.
    @State private var resultText: String?

    var body: some View {
        ZStack(alignment: .bottom) {

            // Embed the `SBSDKDocumentScannerViewModel`-driven camera/detection UI.
            SBSDKScannerView(model: viewModel)

            if let resultText {
                Text(resultText)
                    .padding()
                    .background(.black.opacity(0.6))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding()
            }
        }
        // Subscribe to the frame engine's result/failure events. This replaces
        // `SBSDKDocumentScannerViewControllerDelegate`.
        .onReceive(viewModel.frameEngine.events) { event in
            switch event {
            case .capturedResult(_, let payload):
                if let payload {
                    // Process the detected document.

                    // Convert ImageRef to UIImage if needed.
                    let documentUIImage = try? payload.documentImage.toUIImage()
                    resultText = "Auto-snapped: \(payload.autoSnapped ? "Yes" : "No")"
                }

            case .everyFrame, .validResult:
                // A per-frame sample without a completed snap; nothing to do here.
                break

            case .failure(let error):
                // Handle the error.
                print("Error scanning document: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    DocumentScannerSwiftUIScannerView()
}
