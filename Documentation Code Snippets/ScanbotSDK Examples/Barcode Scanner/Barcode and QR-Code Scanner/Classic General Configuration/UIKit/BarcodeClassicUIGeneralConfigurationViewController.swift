//
//  BarcodeClassicUIGeneralConfigurationViewController.swift
//  ScanbotSDK Examples
//
//  Created by Sebastian Husche on 11.11.24.
//

import Foundation
import ScanbotSDK

class BarcodeClassicUIGeneralConfigurationViewController: UIViewController {

    // The instance of the ClassicUI scanner view controller.
    var scannerViewController: SBSDKBarcodeScannerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the scanner view controller instance.
        self.scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                       parentView: self.view,
                                                                       configuration: .init(),
                                                                       delegate: self)
        
        // Now you can configure some properties using configuration objects or the scanner's
        // model configuration properties.
        //
        // For most viewfinder properties, use scannerViewController.viewModel.configuration.* for reactive updates.
        // For other configurations like general/zoom/energy, still use configuration objects.
        //
        // Configuration objects pattern (for general/zoom/energy):
        // 1. Read the current configuration from the scanner view controller.
        // 2. Modify the configuration to your needs.
        // 3. Pass the modified configuration back to the scanner view controller to apply it.
        //
        // Model configuration properties pattern (for viewfinder and other reactive properties):
        // 1. Directly set properties on scannerViewController.viewModel.configuration.* for reactive updates.
        
        self.applyGeneralConfiguration()
        self.applyZoomConfiguration()
        self.applyEnergyConfiguration()
        self.applyViewFinderConfiguration()
    }
    
    func applyGeneralConfiguration() {

        // The general configuration lets you control timings, video settings and behavior etc.
        
        // Read the current general configuration from the scanner view controller.
        let generalConfiguration = self.scannerViewController.generalConfiguration
        
        // Modify it to your needs.
        generalConfiguration.minimumTimeWithoutDeviceMotionBeforeDetection = 0.5
        // To keep session alive until deallocated.
        generalConfiguration.cameraSessionKeepAliveTimeout = TimeInterval.greatestFiniteMagnitude
        
        // After changing the configuration you need to pass it back to the scanner view controller in order to apply it.
        self.scannerViewController.generalConfiguration = generalConfiguration
    }
    
    func applyZoomConfiguration() {

        // The zoom configuration lets you control the zooming behavior of the scanner view controller, e.g.
        // if zooming is enabled, the zoom range, the initial zoom factor, discrete zoom steps and zoom related gestures.

        // Read the current zoom configuration from the scanner view controller.
        let zoomConfiguration = scannerViewController.zoomConfiguration
        
        // Modify it to your needs.
        zoomConfiguration.isZoomingEnabled = true
        zoomConfiguration.zoomRange = SBSDKZoomRange(minZoom: 1.0, maxZoom: 12.0)
        zoomConfiguration.initialZoomFactor = 2.0
        zoomConfiguration.isPinchToZoomEnabled = true
        
        // After changing the configuration you need to pass it back to the scanner view controller in order to apply it.
        self.scannerViewController.zoomConfiguration = zoomConfiguration
    }
    
    func applyEnergyConfiguration() {
        
        // The energy configuration lets you control the energy consumption of the scanner view controller, e.g. by
        // turning the energy-save-mode on or off, changing the detection rates and the inactivity timeout.

        // Read the current energy configuration from the scanner view controller.
        let energyConfiguration = scannerViewController.energyConfiguration
        
        // Modify it to your needs.
        energyConfiguration.inactivityTimeout = 10.0
        energyConfiguration.detectionRate = 60
        energyConfiguration.energySaveDetectionRate = 5
        
        // After changing the configuration you need to pass it back to the scanner view controller in order to apply it.
        self.scannerViewController.energyConfiguration = energyConfiguration
    }
    
    func applyViewFinderConfiguration() {
        
        // The view finder configuration lets you control the appearance of the view finder,
        // e.g. if it is enabled, its aspect ratio, its colors and style, its offsets and insets and more.
        
        // Use the scanner's model configuration for direct, reactive property updates.
        self.scannerViewController.viewModel.configuration.viewFinder.isViewFinderEnabled = true
        self.scannerViewController.viewModel.configuration.viewFinder.aspectRatio = SBSDKAspectRatio(width: 8.0, height: 5.0)
        self.scannerViewController.viewModel.configuration.viewFinder.lineColor = UIColor.white.withAlphaComponent(0.85)
    }

}

extension BarcodeClassicUIGeneralConfigurationViewController: SBSDKBarcodeScannerViewControllerDelegate {
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  didScanBarcodes codes: [SBSDKBarcodeItem]) {
        
        // Handle scanned barcodes.
    }
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  didFailScanning error: any Error) {
        // Handle the error.
        print("Error scanning barcode: \(error.localizedDescription)")
    }
}

