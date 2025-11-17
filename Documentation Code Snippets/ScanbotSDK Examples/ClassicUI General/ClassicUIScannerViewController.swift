//
//  ClassicUIScannerViewController.swift
//  ScanbotSDK Examples
//
//  Created by Sebastian Husche on 11.11.24.
//

import Foundation
import ScanbotSDK

class ClassicUIScannerViewController: UIViewController {

    // The instance of the ClassicUI scanner view controller, as an example here SBSDKDocumentScannerViewController 
    // is used, but this code applies to all SBSDKBaseScannerViewController-derived ClassicUI scanner view controllers.
    var scannerViewController: SBSDKDocumentScannerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the ClassicUI scanner view controller instance. As an example here `SBSDKDocumentScannerViewController`
        // is used, but this code applies to all SBSDKBaseScannerViewController-derived ClassicUI scanner view controllers.
        self.scannerViewController = SBSDKDocumentScannerViewController(parentViewController: self,
                                                                        parentView: self.view,
                                                                        delegate: self)
        
        // Now you can configure some general properties using one of the configuration objects.
        //
        // As demonstrated in the functions below there are 3 steps:
        // 1. Read the current configuration from the scanner view controller.
        // 2. Modify the configuration to your needs.
        // 3. Pass the modified configuration back to the scanner view controller to apply it.
        
        self.applyGeneralConfiguration()
        self.applyZoomConfiguration()
        self.applyEnergyConfiguration()
        self.applyViewFinderConfiguration()
    }
    
    func applyGeneralConfiguration() {

        // The general configuration lets you control timings, video settings and behaviour etc. 
        
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

        // The zoom configuration lets you control the zooming behaviour of the scanner view controller, e.g. 
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
        // turning the energy-safe-mode on or off, changing the detection rates and the inactivity timeout.

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
        
        // Read the current view finder configuration from the scanner view controller.
        let viewFinderConfiguration = scannerViewController.viewFinderConfiguration
        
        // Modify it to your needs.
        viewFinderConfiguration.isViewFinderEnabled = true
        viewFinderConfiguration.aspectRatio = SBSDKAspectRatio(width: 8.0, height: 5.0)
        viewFinderConfiguration.lineColor = UIColor.white.withAlphaComponent(0.85)
        
        // After changing the configuration you need to pass it back to the scanner view controller in order to apply it.
        self.scannerViewController.viewFinderConfiguration = viewFinderConfiguration
    }

}

extension ClassicUIScannerViewController: SBSDKDocumentScannerViewControllerDelegate {
    
    func documentScannerViewController(_ controller: SBSDKDocumentScannerViewController,
                                       didSnapDocumentImage documentImage: SBSDKImageRef,
                                       on originalImage: SBSDKImageRef,
                                       with result: SBSDKDocumentDetectionResult?,
                                       autoSnapped: Bool) {
        // Process the detected document.
        
        // Convert ImageRef to UIImage if needed.
        let documentUIImage = try? documentImage.toUIImage()
    }
    
    func documentScannerViewController(_ controller: SBSDKDocumentScannerViewController,
                                       didFailScanning error: any Error) {
        // Handle the error.
        print("Error scanning document: \(error.localizedDescription)")
    }
}
 
