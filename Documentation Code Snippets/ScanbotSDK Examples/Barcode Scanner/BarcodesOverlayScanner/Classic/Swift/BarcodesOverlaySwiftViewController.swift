//
//  BarcodesOverlaySwiftViewController.swift
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 29.11.22.
//

import UIKit
import ScanbotSDK

// This is a simple, empty view controller which acts as a container and delegate for the SBSDKBarcodeScannerViewController conforming SBSDKBarcodeTrackingOverlayControllerDelegate.
class BarcodesOverlaySwiftViewController: UIViewController {
    
    // The instance of the scanner view controller.
    var scannerViewController: SBSDKBarcodeScannerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the SBSDKBarcodeScannerViewController instance
        self.scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                       parentView: self.view)
        
        // Set self as a trackingViewController's delegate
        self.scannerViewController.trackingOverlayController.delegate = self
        
        // Enable the barcodes tracking overlay.
        self.scannerViewController.isTrackingOverlayEnabled = true
        
        // Get current tracking configuration object
        let configuration = self.scannerViewController.trackingOverlayController.configuration
        
        // Set the color for the polygons of the tracked barcodes.
        configuration.polygonStyle.polygonColor = UIColor(red: 0, green: 0.81, blue: 0.65, alpha: 0.8)
        
        // Set the color for the polygons of the selected tracked barcodes.
        configuration.polygonStyle.polygonSelectedColor = UIColor(red:0.784, green:0.1, blue:0.235, alpha:0.8)
        
        // Set the text color of the tracked barcodes.
        configuration.textStyle.textColor = UIColor.black
        
        // Set the text background color of the tracked barcodes.
        configuration.textStyle.textBackgroundColor = UIColor(red:0, green:0.81, blue:0.65, alpha:0.8)
        
        // Set the text color of the selected tracked barcodes.
        configuration.textStyle.selectedTextColor = UIColor.white
        
        // Set the text background color of the selected tracked barcodes.
        configuration.textStyle.textBackgroundSelectedColor = UIColor(red:0.784, green:0.1, blue:0.235, alpha:0.8)
        
        // Set the text format of the tracked barcodes.
        configuration.textStyle.trackingOverlayTextFormat = .codeAndType
        
        // Set the tracking configuration to apply it.
        self.scannerViewController.trackingOverlayController.configuration = configuration
    }
}

// The implementation of the SBSDKBarcodeTrackingOverlayControllerDelegate.
extension BarcodesOverlaySwiftViewController: SBSDKBarcodeTrackingOverlayControllerDelegate {
    
    // Implement this method to handle user's selection of a tracked barcode.
    func barcodeTrackingOverlay(_ controller: SBSDKBarcodeTrackingOverlayController,
                                didTapOnBarcode barcode: SBSDKBarcodeScannerResult) {
        // Process the barcode selected by the user.
    }
    
    // Implement this method when you need to customize the polygon style individually for every barcode detected.
    func barcodeTrackingOverlay(_ controller: SBSDKBarcodeTrackingOverlayController,
                                polygonStyleFor barcode: SBSDKBarcodeScannerResult) -> SBSDKBarcodeTrackedViewPolygonStyle? {
        
        let style = SBSDKBarcodeTrackedViewPolygonStyle()
        if barcode.type == SBSDKBarcodeType.qrCode {
            style.polygonColor = UIColor.red
            style.polygonBackgroundColor = UIColor.purple.withAlphaComponent(0.2)
        }
        return style
    }
    
    // Implement this method when you need to customize the text style individually for every barcode detected.
    func barcodeTrackingOverlay(_ controller: SBSDKBarcodeTrackingOverlayController,
                                textStyleFor barcode: SBSDKBarcodeScannerResult) -> SBSDKBarcodeTrackedViewTextStyle? {
        
        let style = SBSDKBarcodeTrackedViewTextStyle()
        if barcode.type == SBSDKBarcodeType.qrCode {
            style.textBackgroundColor = UIColor.purple.withAlphaComponent(0.2)
        }
        return style
    }
}
