//
//  ClassicUIScannerSwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct ClassicUIScannerSwiftUIView: View {

    @State private var viewModel = try! SBSDKDocumentScannerViewModel()

    var body: some View {
        SBSDKScannerView(model: viewModel)
            .onAppear {
                applyGeneralConfiguration()
                applyZoomConfiguration()
                applyEnergyConfiguration()
                applyViewFinderConfiguration()
            }
            .onReceive(viewModel.frameEngine.events) { event in
                switch event {
                case .capturedResult(_, let payload):
                    if let payload {
                        // Process the detected document.

                        // Convert ImageRef to UIImage if needed.
                        let documentUIImage = try? payload.documentImage.toUIImage()
                    }

                case .everyFrame, .validResult:
                    break

                case .failure(let error):
                    // Handle the error.
                    print("Error scanning document: \(error.localizedDescription)")
                }
            }
    }

    func applyGeneralConfiguration() {

        // General scanner behavior lives on the view model's configuration. Timings, motion and video
        // settings are set directly on it — no configuration snapshot to read/modify/write.
        viewModel.configuration.userInterface.minimumTimeWithoutDeviceMotionBeforeDetection = 0.5

        // Camera-session-level settings live on `viewModel.camera`. Setting the keep-alive timeout
        // to `.greatestFiniteMagnitude` keeps the camera session alive until the view model is
        // deallocated.
        viewModel.camera.keepAliveTimeout = .greatestFiniteMagnitude
    }

    func applyZoomConfiguration() {

        // Zooming is a camera-session feature and is configured on `viewModel.camera`. Set gestures
        // and discrete zoom steps directly — changes take effect immediately.
        let camera = viewModel.camera
        camera.isZoomingEnabled = true
        camera.isPinchToZoomEnabled = true
        camera.isDoubleTapToZoomEnabled = true
        // Zoom steps define the discrete stops used by double-tap zooming and constrain the
        // effective zoom range. The first entry is the minimum, the last entry the maximum.
        camera.zoomSteps = [1.0, 12.0]
    }

    func applyEnergyConfiguration() {

        // Energy-saving behavior (detection rates, inactivity timeout) lives on the view model's
        // user-interface sub-configuration and can be tweaked live.
        let userInterface = viewModel.configuration.userInterface
        userInterface.isEnergySavingEnabled = true
        userInterface.inactivityTimeout = 10.0
        userInterface.detectionRate = 60
        userInterface.energySaveDetectionRate = 5
    }

    func applyViewFinderConfiguration() {

        // The view finder lives on the view model's view-finder sub-configuration. Toggle it on, change its
        // aspect ratio and appearance — SwiftUI-backed classic UI updates automatically.
        let viewFinder = viewModel.configuration.viewFinder
        viewFinder.isViewFinderEnabled = true
        viewFinder.aspectRatio = SBSDKAspectRatio(width: 8.0, height: 5.0)
        viewFinder.lineColor = UIColor.white.withAlphaComponent(0.85)
    }
}

#Preview {
    ClassicUIScannerSwiftUIView()
}
