//
//  BarcodesBatchSwiftViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 20.05.21.
//

import UIKit
import ScanbotSDK

// This is a simple, empty view controller which acts as a container and delegate for the SBSDKBarcodeScannerViewController.
class BarcodesBatchSwiftViewController: UIViewController {

    // The instance of the scanner view controller.
    var scannerViewController: SBSDKBarcodeScannerViewController!

    // Property to indicate whether you want scanner to detect barcodes or not.
    var shouldDetectBarcodes = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the SBSDKBarcodeScannerViewController instance
        self.scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self, 
                                                                       parentView: self.view, 
                                                                       delegate: self)
        
        // Get current view finder configuration object
        let config = self.scannerViewController.viewFinderConfiguration
        
        // Enable the view finder.
        config.isViewFinderEnabled = true
        
        // Set the finder's aspect ratio.
        config.aspectRatio = SBSDKAspectRatio(width: 2, height: 1)
        
        // Set the finder's minimum insets.
        config.minimumInset = UIEdgeInsets(top: 100, left: 50, bottom: 100, right: 50)
        
        // Configure the view finder colors and line properties.
        config.lineColor = UIColor.red
        config.backgroundColor = UIColor.red.withAlphaComponent(0.1) 
        config.lineWidth = 2
        config.lineCornerRadius = 8
        
        // Set the view finder configuration to apply it.
        self.scannerViewController.viewFinderConfiguration = config

        // Get current energy configuration.
        let energyConfig = self.scannerViewController.energyConfiguration

        // Set detection rate.
        energyConfig.detectionRate = 5
        
        // Set the energy configuration to apply it.
        self.scannerViewController.energyConfiguration = energyConfig
        
        // Define and set barcode types that should be accepted by the scanner.
        let commonTypes = SBSDKBarcodeType.commonTypes
        self.scannerViewController.acceptedBarcodeTypes = commonTypes
    }
}

// The implementation of the SBSDKBarcodeScannerViewControllerDelegate.
extension BarcodesBatchSwiftViewController: SBSDKBarcodeScannerViewControllerDelegate {

    // Implement this function to process detected barcodes.
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  didDetectBarcodes codes: [SBSDKBarcodeScannerResult]) {
        // Process the detected barcodes.
    }
    
    // Implement this function when you need to pause the detection (e.g. when showing results)
    func barcodeScannerControllerShouldDetectBarcodes(_ controller: SBSDKBarcodeScannerViewController) -> Bool {
        return self.shouldDetectBarcodes
    }
}
