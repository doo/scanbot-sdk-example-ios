//
//  BarcodeScannerDataParsingSwiftViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 02.06.21.
//

import UIKit
import ScanbotSDK

// This is a simple, empty view controller which acts as a container and delegate for the SBSDKBarcodeScannerViewController.
class BarcodeScannerDataParsingSwiftViewController: UIViewController {

    // The instance of the scanner view controller.
    var scannerViewController: SBSDKBarcodeScannerViewController!

    // The variable to indicate whether you want the scanner to detect barcodes or not.
    var shouldDetectBarcodes = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the SBSDKBarcodeScannerViewController instance.
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

// The implementation of SBSDKBarcodeScannerViewControllerDelegate.
extension BarcodeScannerDataParsingSwiftViewController: SBSDKBarcodeScannerViewControllerDelegate {

    // Implement this function to process detected barcodes.
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  didDetectBarcodes codes: [SBSDKBarcodeScannerResult]) {
        // Process the detected barcodes.
        
        let barcode = codes.first
        
        // Parse the resulted document as a Swiss QR document and retrieve it's elements.
        if let document = SBSDKBarcodeDocumentSwissQR(document: barcode?.parsedDocument) {
            
            // Enumerate the Swiss QR code data fields.
            for field in document.document.fields {
                // Do something with the fields.
            }
        }
    }
    
    // Implement this function when you need to pause the detection (e.g. when showing the results).
    func barcodeScannerControllerShouldDetectBarcodes(_ controller: SBSDKBarcodeScannerViewController) -> Bool {
        return self.shouldDetectBarcodes
    }
}
