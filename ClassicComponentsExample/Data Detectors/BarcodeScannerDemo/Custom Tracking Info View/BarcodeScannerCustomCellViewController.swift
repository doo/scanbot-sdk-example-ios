//
//  BarcodeScannerCustomCellViewController.swift
//  ClassicComponentsExample
//
//  Created by Rana Sohaib on 17.03.23.
//  Copyright © 2023 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class BarcodeScannerCustomCellViewController: BarcodeScannerViewController, SBSDKBarcodeTrackingOverlayControllerDelegate {
    
    enum ColorScheme {
        case polygonForeground
        case polygonBackground
        case textBackground
        case textForeground
        
        func colorForCode(_ code: SBSDKBarcodeScannerResult) -> UIColor {
            let isTwoD = SBSDKBarcodeType.twoDTypes.contains(code.type)
            let baseColor = isTwoD ? UIColor.systemRed : UIColor.systemBlue
            switch self {
            case .polygonBackground:
                return baseColor.withAlphaComponent(0.2)
            case .polygonForeground:
                return baseColor.withAlphaComponent(0.8)
            case .textBackground:
                return baseColor.withAlphaComponent(0.8)
            case .textForeground:
                return .white
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = SBSDKBarcodeTrackingOverlayConfiguration()
        config.customView = CustomTrackedBarcodeView()
        scannerViewController?.isTrackingOverlayEnabled = true
        scannerViewController?.trackingOverlayController.configuration = config
        scannerViewController?.trackingOverlayController.delegate = self
    }
    
    func barcodeTrackingOverlay(_ controller: SBSDKBarcodeTrackingOverlayController, 
                                didChangeSelectedBarcodes selectedBarcodes: [SBSDKBarcodeScannerResult]) {
        
        if selectedBarcodes.count > 0 {
            displayResults(selectedBarcodes)
        }
    }
        
    func barcodeTrackingOverlay(_ controller: SBSDKBarcodeTrackingOverlayController, 
                                polygonStyleFor barcode: SBSDKBarcodeScannerResult) -> SBSDKBarcodeTrackedViewPolygonStyle? {
        
        let style = SBSDKBarcodeTrackedViewPolygonStyle()
        style.polygonDrawingEnabled = true
        style.cornerRadius = 8
        style.borderWidth = 2
        style.polygonColor = ColorScheme.polygonForeground.colorForCode(barcode)
        style.polygonBackgroundColor = ColorScheme.polygonBackground.colorForCode(barcode)
        return style
    }
    
    func barcodeTrackingOverlay(_ controller: SBSDKBarcodeTrackingOverlayController, 
                                textStyleFor barcode: SBSDKBarcodeScannerResult) -> SBSDKBarcodeTrackedViewTextStyle? {
        
        let style = SBSDKBarcodeTrackedViewTextStyle()
        style.textDrawingEnabled = true
        style.trackingOverlayTextFormat = .codeAndType
        style.textColor = ColorScheme.textForeground.colorForCode(barcode)
        style.textBackgroundColor = ColorScheme.textBackground.colorForCode(barcode)
        return style
    }
    
}
