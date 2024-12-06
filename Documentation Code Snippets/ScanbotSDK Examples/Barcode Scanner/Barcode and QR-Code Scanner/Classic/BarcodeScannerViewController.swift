//
//  BarcodeScannerViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 02.06.21.
//

import UIKit
import ScanbotSDK

// This is a simple, empty view controller which acts as a container and delegate for the SBSDKBarcodeScannerViewController.
class BarcodeScannerViewController: UIViewController {

    // The instance of the scanner view controller.
    var scannerViewController: SBSDKBarcodeScannerViewController!

    // The variable to indicate whether you want the scanner to detect barcodes or not.
    var shouldDetectBarcodes = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // The barcode formats to be scanned.
        let formatsToDetect = SBSDKBarcodeFormats.all
        
        // Create an instance of `SBSDKBarcodeFormatCommonConfiguration`.
        let formatConfiguration = SBSDKBarcodeFormatCommonConfiguration(formats: formatsToDetect)
        
        // Create an instance of `SBSDKBarcodeScannerConfiguration`.
        let configuration = SBSDKBarcodeScannerConfiguration(barcodeFormatConfigurations: [formatConfiguration])
        
        // Create the `SBSDKBarcodeScannerViewController` instance.
        self.scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                       parentView: self.view,
                                                                       configuration: configuration,
                                                                       delegate: self)
        
        // Get the current view finder configuration object.
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

        // Get the current energy configuration.
        let energyConfig = self.scannerViewController.energyConfiguration

        // Set the detection rate.
        energyConfig.detectionRate = 5
        
        // Set the energy configuration to apply it.
        self.scannerViewController.energyConfiguration = energyConfig
    }
}

// The implementation of SBSDKBarcodeScannerViewControllerDelegate.
extension BarcodeScannerViewController: SBSDKBarcodeScannerViewControllerDelegate {
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  didScanBarcodes codes: [SBSDKBarcodeItem]) {
        // Process the detected barcodes.
        print(codes)
    }
    
    // Implement this function when you need to pause the detection (e.g. when showing the results).
    func barcodeScannerControllerShouldScanBarcodes(_ controller: SBSDKBarcodeScannerViewController) -> Bool {
        return self.shouldDetectBarcodes
    }
}
