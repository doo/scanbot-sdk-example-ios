//
//  BarcodeScanAndCountSwiftViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 06.06.23.
//

import Foundation
import ScanbotSDK

// This is a simple, empty view controller which acts as a container and delegate for the SBSDKBarcodeScanAndCountViewController.
class BarcodeScanAndCountSwiftViewController: UIViewController {
    
    // The instance of the scanner view controller.
    var scannerViewController: SBSDKBarcodeScanAndCountViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the SBSDKBarcodeScanAndCountViewController instance
        self.scannerViewController = SBSDKBarcodeScanAndCountViewController(parentViewController: self,
                                                                            parentView: self.view)
        
        // Create new instance of the polygon style.
        let polygonStyle = SBSDKScanAndCountPolygonStyle()
        
        // Enable the barcode polygon overlay.
        polygonStyle.polygonDrawingEnabled = true
        
        // Set the color for the results overlays polygons.
        polygonStyle.polygonColor = UIColor(red: 0, green: 0.81, blue: 0.65, alpha: 0.8)
        
        // Set the color for the polygon's fill color.
        polygonStyle.polygonFillColor = UIColor(red: 0, green: 0.81, blue: 0.65, alpha: 0.2)
        
        // Set the line width for the polygon.
        polygonStyle.lineWidth = 2
        
        // Set the corner radius for the polygon.
        polygonStyle.cornerRadius = 8
        
        // Set the polygon style to apply it.
        self.scannerViewController.polygonStyle = polygonStyle
        
        // Set the capture mode of the scanner.
        self.scannerViewController.captureMode = .capturedImage
    }
}

// The implementation of SBSDKBarcodeScanAndCountViewControllerDelegate.
extension BarcodeScannerSwiftViewController: SBSDKBarcodeScanAndCountViewControllerDelegate {
    
    // Implement this function to process detected barcodes.
    func barcodeScanAndCount(_ controller: SBSDKBarcodeScanAndCountViewController,
                             didDetectBarcodes codes: [SBSDKBarcodeScannerResult]) {
        // Process the detected barcodes.
    }
    
    // Implement this optional function when you need a custom overlay to be displayed for the detected barcode.
    func barcodeScanAndCount(_ controller: SBSDKBarcodeScanAndCountViewController,
                             overlayForBarcode code: SBSDKBarcodeScannerResult) -> UIView? {
        // provide a custom overlay view for the barcode
        return UIImageView(image: UIImage(named: "<image_name>"))
    }
}
