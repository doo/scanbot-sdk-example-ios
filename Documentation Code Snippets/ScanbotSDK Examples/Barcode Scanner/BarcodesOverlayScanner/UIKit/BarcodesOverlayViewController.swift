//
//  BarcodesOverlayViewController.swift
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 29.11.22.
//

import UIKit
import ScanbotSDK

// This is a simple, empty view controller which acts as a container and delegate for the `SBSDKBarcodeScannerViewController` conforming to `SBSDKBarcodeTrackingOverlayControllerDelegate`.
class BarcodesOverlayViewController: UIViewController {
    
    // The instance of the scanner view controller.
    var scannerViewController: SBSDKBarcodeScannerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // The barcode formats to be detected.
        let formatsToDetect = SBSDKBarcodeFormats.all
        
        // Create an instance of `SBSDKBarcodeFormatCommonConfiguration`, passing the desired barcode formats.
        let formatConfiguration = SBSDKBarcodeFormatCommonConfiguration(formats: formatsToDetect)
        
        // Create an instance of `SBSDKBarcodeScannerConfiguration`, passing the format configuration.
        let configuration = SBSDKBarcodeScannerConfiguration(barcodeFormatConfigurations: [formatConfiguration])
        
        // Enable the barcode image extraction.
        configuration.returnBarcodeImage = true
        
        // Create the SBSDKBarcodeScannerViewController instance, passing the configuration.
        self.scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                       parentView: self.view,
                                                                       configuration: configuration)
        
        // Set self as a trackingViewController's delegate.
        self.scannerViewController.viewModel.trackingOverlay.delegate = self
        
        // Enable the barcodes tracking overlay.
        self.scannerViewController.viewModel.trackingOverlay.isTrackingOverlayEnabled = true
        
        // Get current tracking configuration object.
        let trackingConfiguration = self.scannerViewController.viewModel.trackingOverlay.trackingOverlayConfiguration
        
        // Set the color for the polygons of the tracked barcodes.
        trackingConfiguration.defaultStyle.polygonColor = UIColor(red: 0, green: 0.81, blue: 0.65, alpha: 0.8)
        
        // Set the text color of the tracked barcodes.
        trackingConfiguration.defaultStyle.textColor = UIColor.black
        
        // Set the text background color of the tracked barcodes.
        trackingConfiguration.defaultStyle.textBackgroundColor = UIColor(red:0, green:0.81, blue:0.65, alpha:0.8)
        
        // Set the text format of the tracked barcodes.
        trackingConfiguration.defaultStyle.textFormat = .codeAndType
        
        // Set the style used for selected tracked barcodes.
        let selectionStyle = trackingConfiguration.defaultStyle.copy() as! SBSDKBarcodeTrackingOverlayStyle
        selectionStyle.polygonColor = UIColor(red:0.784, green:0.1, blue:0.235, alpha:0.8)
        selectionStyle.textColor = UIColor.white
        selectionStyle.textBackgroundColor = UIColor(red:0.784, green:0.1, blue:0.235, alpha:0.8)
        trackingConfiguration.selectionStyle = selectionStyle
        
        // Re-assign to commit the changes and force the overlay to redraw already-tracked items.
        self.scannerViewController.viewModel.trackingOverlay.trackingOverlayConfiguration = trackingConfiguration
    }
}

// The implementation of the `SBSDKBarcodeTrackingOverlayControllerDelegate`.
extension BarcodesOverlayViewController: SBSDKBarcodeTrackingOverlayControllerDelegate {
    
    func barcodeTrackingOverlay(_ controller: SBSDKBarcodeTrackingOverlayController,
                                didTapOnBarcode barcode: SBSDKBarcodeItem) {
        // Process the barcode selected by the user.
        print(barcode)
        
        // Get the source image.
        let sourceImage = try? barcode.sourceImage?.toUIImage()
    }
    
    // Implement this method if you need to customize the style individually for each barcode detected.
    func barcodeTrackingOverlay(_ controller: SBSDKBarcodeTrackingOverlayController,
                                styleFor item: SBSDKBarcodeTrackingOverlayItem,
                                proposedStyle: SBSDKBarcodeTrackingOverlayStyle) -> SBSDKBarcodeTrackingOverlayStyle {
        guard item.barcode.format == SBSDKBarcodeFormat.qrCode else { return proposedStyle }
        let style = proposedStyle.copy() as! SBSDKBarcodeTrackingOverlayStyle
        style.polygonColor = UIColor.red
        style.polygonBackgroundColor = UIColor.purple.withAlphaComponent(0.2)
        style.textBackgroundColor = UIColor.purple.withAlphaComponent(0.2)
        return style
    }
}
