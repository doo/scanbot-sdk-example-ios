//
//  BarcodeClassicUIGeneralConfigurationSwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct BarcodeClassicUIGeneralConfigurationSwiftUIView: View {

    @State private var model: SBSDKBarcodeScannerViewModel = {
        return try! SBSDKBarcodeScannerViewModel(scannerConfiguration: .init())
    }()

    var body: some View {
        SBSDKScannerView(model: model)
            .onAppear {
                applyGeneralConfiguration()
                applyZoomConfiguration()
                applyEnergyConfiguration()
                applyViewFinderConfiguration()
            }
            .onReceive(model.frameEngine.events) { event in
                switch event {
                case .validResult:
                    // Handle scanned barcodes.
                    break

                case .everyFrame:
                    break

                case .failure(let error):
                    // Handle the error.
                    print("Error scanning barcode: \(error.localizedDescription)")
                }
            }
    }
    
    func applyGeneralConfiguration() {

        // The general configuration lets you control timings, video settings and behavior etc.
        
        // Read the current general configuration from the scanner view controller.
        let generalConfiguration = model.configuration.userInterface
        
        // Modify it to your needs.
        generalConfiguration.minimumTimeWithoutDeviceMotionBeforeDetection = 0.5
        // To keep session alive until deallocated.
        model.camera.keepAliveTimeout = TimeInterval.greatestFiniteMagnitude
    }
    
    func applyZoomConfiguration() {

        // The zoom configuration lets you control the zooming behavior of the scanner view controller, e.g.
        // if zooming is enabled, the zoom range, the initial zoom factor, discrete zoom steps and zoom related gestures.

        // Read the current zoom configuration from the scanner view controller.
        let camera = model.camera
        
        // Modify it to your needs.
        camera.isZoomingEnabled = true
        camera.zoomRange = SBSDKZoomRange(minZoom: 1.0, maxZoom: 12.0)
        camera.setZoom(2.0, animated: false)
        camera.isPinchToZoomEnabled = true
    }
    
    func applyEnergyConfiguration() {
        
        // The energy configuration lets you control the energy consumption of the scanner view controller, e.g. by
        // turning the energy-save-mode on or off, changing the detection rates and the inactivity timeout.

        // Read the current energy configuration from the scanner view controller.
        let energyConfiguration = model.configuration.userInterface
        
        // Modify it to your needs.
        energyConfiguration.inactivityTimeout = 10.0
        energyConfiguration.detectionRate = 60
        energyConfiguration.energySaveDetectionRate = 5
    }
    
    func applyViewFinderConfiguration() {
        
        // The view finder configuration lets you control the appearance of the view finder,
        // e.g. if it is enabled, its aspect ratio, its colors and style, its offsets and insets and more.
        
        // Use the scanner's model configuration for direct, reactive property updates.
        model.configuration.viewFinder.isViewFinderEnabled = true
        model.configuration.viewFinder.aspectRatio = SBSDKAspectRatio(width: 8.0, height: 5.0)
        model.configuration.viewFinder.lineColor = UIColor.white.withAlphaComponent(0.85)
    }
}

#Preview {
    BarcodeClassicUIGeneralConfigurationSwiftUIView()
}
