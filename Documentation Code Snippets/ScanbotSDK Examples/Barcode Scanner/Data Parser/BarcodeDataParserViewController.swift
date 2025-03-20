//
//  BarcodeDataParserViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 25.10.24.
//

import UIKit
import ScanbotSDK

// This is a simple, empty view controller which acts as a container
// and delegate for the `SBSDKBarcodeScannerViewController`.
class BarcodeDataParserViewController: UIViewController {

    // The instance of the scanner view controller.
    var scannerViewController: SBSDKBarcodeScannerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // The barcode document formats to be scanned.
        let documentFormatsToDetect = [SBSDKBarcodeDocumentFormat.swissQr]
        
        // Get the supported barcode formats for the document formats set above.
        let barcodeFormats = SBSDKBarcodeDocumentFormat.supportedBarcodeFormats(for: documentFormatsToDetect)
        
        // Create an instance of `SBSDKBarcodeFormatCommonConfiguration`.
        let formatConfiguration = SBSDKBarcodeFormatCommonConfiguration(formats: barcodeFormats)
        
        // Create an instance of `SBSDKBarcodeScannerConfiguration`.
        let configuration = SBSDKBarcodeScannerConfiguration(barcodeFormatConfigurations: [formatConfiguration],
                                                             extractedDocumentFormats: documentFormatsToDetect)
        
        // Enable the barcode image extraction.
        configuration.returnBarcodeImage = true
        
        // Create the SBSDKBarcodeScannerViewController instance.
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

// The implementation of `SBSDKBarcodeScannerViewControllerDelegate`.
extension BarcodeDataParserViewController: SBSDKBarcodeScannerViewControllerDelegate {
    
    // Implement this function to process detected barcodes.
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  didScanBarcodes codes: [SBSDKBarcodeItem]) {
        
        // Process the detected barcodes.
        let barcode = codes.first
        
        // Get the source image.
        let sourceImage = barcode?.sourceImage?.toUIImage()
        
        // Run the parser and check the result.
        if let document = SBSDKBarcodeDocumentModelSwissQR(document: barcode?.extractedDocument) {
            
            // Enumerate the Swiss QR code data fields.
            for field in document.document.fields {
                
                // Do something with the fields.
                print("\(field.type.fullName) = \(field.value?.text)")
            }
        }
    }
    
    // Implement this function if you need to pause the detection (e.g. when showing the results).
    func barcodeScannerControllerShouldScanBarcodes(_ controller: SBSDKBarcodeScannerViewController) -> Bool {
        return true
    }
}
