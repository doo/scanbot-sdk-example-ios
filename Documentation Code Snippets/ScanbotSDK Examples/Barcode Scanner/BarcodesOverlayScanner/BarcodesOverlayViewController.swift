//
//  BarcodesOverlayViewController.swift
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 29.11.22.
//

import UIKit
import ScanbotSDK

// This is a simple, empty view controller which acts as a container and delegate for the `SBSDKBarcodeScannerViewController` conforming `SBSDKBarcodeTrackingOverlayControllerDelegate`.
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
        self.scannerViewController.trackingOverlayController.delegate = self
        
        // Enable the barcodes tracking overlay.
        self.scannerViewController.isTrackingOverlayEnabled = true
        
        // Get current tracking configuration object.
        let trackingConfiguration = self.scannerViewController.trackingOverlayController.configuration
        
        // Set the color for the polygons of the tracked barcodes.
        trackingConfiguration.polygonStyle.polygonColor = UIColor(red: 0, green: 0.81, blue: 0.65, alpha: 0.8)
        
        // Set the color for the polygons of the selected tracked barcodes.
        trackingConfiguration.polygonStyle.polygonSelectedColor = UIColor(red:0.784, green:0.1, blue:0.235, alpha:0.8)
        
        // Set the text color of the tracked barcodes.
        trackingConfiguration.textStyle.textColor = UIColor.black
        
        // Set the text background color of the tracked barcodes.
        trackingConfiguration.textStyle.textBackgroundColor = UIColor(red:0, green:0.81, blue:0.65, alpha:0.8)
        
        // Set the text color of the selected tracked barcodes.
        trackingConfiguration.textStyle.selectedTextColor = UIColor.white
        
        // Set the text background color of the selected tracked barcodes.
        trackingConfiguration.textStyle.textBackgroundSelectedColor = UIColor(red:0.784, green:0.1, blue:0.235, alpha:0.8)
        
        // Set the text format of the tracked barcodes.
        trackingConfiguration.textStyle.trackingOverlayTextFormat = .codeAndType
        
        // Set the tracking configuration to apply it.
        self.scannerViewController.trackingOverlayController.configuration = trackingConfiguration
    }
}

// The implementation of the `SBSDKBarcodeTrackingOverlayControllerDelegate`.
extension BarcodesOverlayViewController: SBSDKBarcodeTrackingOverlayControllerDelegate {
    
    func barcodeTrackingOverlay(_ controller: SBSDKBarcodeTrackingOverlayController,
                                didTapOnBarcode barcode: SBSDKBarcodeItem) {
        // Process the barcode selected by the user.
        print(barcode)
        
        // Get the source image.
        let sourceImage = barcode.sourceImage?.toUIImage()
        
    }
    
    // Implement this method if you need to customize the polygon style individually for each barcode detected.
    func barcodeTrackingOverlay(_ controller: SBSDKBarcodeTrackingOverlayController, polygonStyleFor barcode: SBSDKBarcodeItem) -> SBSDKBarcodeTrackedViewPolygonStyle? {
        let style = SBSDKBarcodeTrackedViewPolygonStyle()
        if barcode.format == SBSDKBarcodeFormat.qrCode {
            style.polygonColor = UIColor.red
            style.polygonBackgroundColor = UIColor.purple.withAlphaComponent(0.2)
        }
        return style
    }
    
    // Implement this method if you need to customize the text style individually for each barcode detected.
    func barcodeTrackingOverlay(_ controller: SBSDKBarcodeTrackingOverlayController, textStyleFor barcode: SBSDKBarcodeItem) -> SBSDKBarcodeTrackedViewTextStyle? {
        let style = SBSDKBarcodeTrackedViewTextStyle()
        if barcode.format == SBSDKBarcodeFormat.qrCode {
            style.textBackgroundColor = UIColor.purple.withAlphaComponent(0.2)
        }
        return style
    }
}
