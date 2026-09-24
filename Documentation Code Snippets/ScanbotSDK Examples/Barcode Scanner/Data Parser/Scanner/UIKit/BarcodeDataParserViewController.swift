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
        
        // Enable the view finder.
        self.scannerViewController.viewModel.configuration.viewFinder.isViewFinderEnabled = true
        
        // Set the finder's aspect ratio.
        self.scannerViewController.viewModel.configuration.viewFinder.aspectRatio = SBSDKAspectRatio(width: 2, height: 1)
        
        // Set the finder's minimum insets.
        self.scannerViewController.viewModel.configuration.viewFinder.minimumInset = UIEdgeInsets(top: 100, left: 50, bottom: 100, right: 50)
        
        // Configure the view finder colors and line properties.
        self.scannerViewController.viewModel.configuration.viewFinder.lineColor = UIColor.red
        self.scannerViewController.viewModel.configuration.viewFinder.backgroundColor = UIColor.red.withAlphaComponent(0.1)
        self.scannerViewController.viewModel.configuration.viewFinder.lineWidth = 2
        self.scannerViewController.viewModel.configuration.viewFinder.lineCornerRadius = 8
        

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
        let sourceImage = try? barcode?.sourceImage?.toUIImage()
        
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
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  didFailScanning error: any Error) {
        // Handle the error.
        print("Error scanning barcode: \(error.localizedDescription)")
    }
}
