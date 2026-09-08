//
//  ClassicUIScannerViewController.swift
//  ScanbotSDK Examples
//
//  Created by Sebastian Husche on 11.11.24.
//

import Foundation
import ScanbotSDK

class ClassicUIScannerViewController: UIViewController {

    // The instance of the ClassicUI scanner view controller. `SBSDKDocumentScannerViewController` is used
    // here as an example, but this code applies to all `SBSDKBaseScannerViewController`-derived ClassicUI
    // scanner view controllers.
    var scannerViewController: SBSDKDocumentScannerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the ClassicUI scanner view controller instance. `SBSDKDocumentScannerViewController`
        // is used here as an example, but this code applies to all `SBSDKBaseScannerViewController`-
        // derived ClassicUI scanner view controllers.
        self.scannerViewController = SBSDKDocumentScannerViewController(parentViewController: self,
                                                                        parentView: self.view,
                                                                        delegate: self)

        // The scanner view controller exposes its state through its `model` (an
        // `SBSDKBaseScannerModel`-derived observable object) and the underlying `viewModel.camera`.
        // Set properties on either directly to configure the scanner at runtime. Both are
        // KVO-observable, so you can also react to their changes from Swift, SwiftUI and Obj-C.

        self.applyGeneralConfiguration()
        self.applyZoomConfiguration()
        self.applyEnergyConfiguration()
        self.applyViewFinderConfiguration()
    }

    func applyGeneralConfiguration() {

        // General scanner behavior lives on the model's configuration. Timings, motion and video
        // settings are set directly on it — no configuration snapshot to read/modify/write.
        scannerViewController.viewModel.configuration.userInterface.minimumTimeWithoutDeviceMotionBeforeDetection = 0.5

        // Camera-session-level settings live on `viewModel.camera`. Setting the keep-alive timeout
        // to `.greatestFiniteMagnitude` keeps the camera session alive until the model is
        // deallocated.
        scannerViewController.viewModel.camera.keepAliveTimeout = .greatestFiniteMagnitude
    }

    func applyZoomConfiguration() {

        // Zooming is a camera-session feature and is configured on `viewModel.camera`. Set gestures
        // and discrete zoom steps directly — changes take effect immediately.
        let camera = scannerViewController.viewModel.camera
        camera.isZoomingEnabled = true
        camera.isPinchToZoomEnabled = true
        camera.isDoubleTapToZoomEnabled = true
        // Zoom steps define the discrete stops used by double-tap zooming and constrain the
        // effective zoom range. The first entry is the minimum, the last entry the maximum.
        camera.zoomSteps = [1.0, 12.0]
    }

    func applyEnergyConfiguration() {

        // Energy-saving behavior (detection rates, inactivity timeout) lives on the model's
        // user-interface sub-configuration and can be tweaked live.
        let userInterface = scannerViewController.viewModel.configuration.userInterface
        userInterface.isEnergySavingEnabled = true
        userInterface.inactivityTimeout = 10.0
        userInterface.detectionRate = 60
        userInterface.energySaveDetectionRate = 5
    }

    func applyViewFinderConfiguration() {

        // The view finder lives on the model's view-finder sub-configuration. Toggle it on, change its
        // aspect ratio and appearance — SwiftUI-backed classic UI updates automatically.
        let viewFinder = scannerViewController.viewModel.configuration.viewFinder
        viewFinder.isViewFinderEnabled = true
        viewFinder.aspectRatio = SBSDKAspectRatio(width: 8.0, height: 5.0)
        viewFinder.lineColor = UIColor.white.withAlphaComponent(0.85)
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
 
