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
    
    private var barcodeItemSelection: SBSDKBarcodeItemSelection = SBSDKBarcodeItemSelection()
    
    enum ColorScheme {
        case polygonForeground
        case polygonBackground
        case textBackground
        case textForeground
        
        func colorForCode(_ code: SBSDKBarcodeItem) -> UIColor {
            let isTwoD = SBSDKBarcodeFormats.twod.contains(code.format)
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
        
        // The tracking overlay is configured through the scanner's view model.
        guard let trackingOverlay = scannerViewController?.viewModel.trackingOverlay else { return }
        
        let configuration = SBSDKBarcodeTrackingOverlayConfiguration()
        
        // We manage the selection of the barcodes ourselves in `didTapOnBarcode`.
        configuration.selectionMode = .none
        
        trackingOverlay.trackingOverlayConfiguration = configuration
        trackingOverlay.isTrackingOverlayEnabled = true
        trackingOverlay.delegate = self
    }
    
    /// Builds the style of a tracked barcode. Polygon and text styling are combined into one style object.
    private func style(for barcode: SBSDKBarcodeItem) -> SBSDKBarcodeTrackingOverlayStyle {
        let style = SBSDKBarcodeTrackingOverlayStyle()
        
        style.polygonDrawingEnabled = true
        style.cornerRadius = 8
        style.borderWidth = 2
        style.polygonColor = ColorScheme.polygonForeground.colorForCode(barcode)
        style.polygonBackgroundColor = ColorScheme.polygonBackground.colorForCode(barcode)
        
        style.textDrawingEnabled = true
        style.textFormat = .codeAndType
        style.textColor = ColorScheme.textForeground.colorForCode(barcode)
        style.textBackgroundColor = ColorScheme.textBackground.colorForCode(barcode)
        
        return style
    }
    
    func barcodeTrackingOverlay(_ controller: SBSDKBarcodeTrackingOverlayController,
                                didTapOnBarcode barcode: SBSDKBarcodeItem) {
        barcodeItemSelection.toggleSelection(for: barcode)
        if barcodeItemSelection.allBarcodes.count > 0 {
            displayResults(barcodeItemSelection.allBarcodes)
        }
    }
    
    func barcodeTrackingOverlay(_ controller: SBSDKBarcodeTrackingOverlayController,
                                styleFor item: SBSDKBarcodeTrackingOverlayItem,
                                proposedStyle: SBSDKBarcodeTrackingOverlayStyle) -> SBSDKBarcodeTrackingOverlayStyle {
        return style(for: item.barcode)
    }
    
    func barcodeTrackingOverlay(_ controller: SBSDKBarcodeTrackingOverlayController,
                                customViewFor item: SBSDKBarcodeTrackingOverlayItem) -> UIView {
        let view = CustomTrackedBarcodeView.make(with: item.barcode)
        view.update(with: item, style: style(for: item.barcode))
        return view
    }
    
    func barcodeTrackingOverlay(_ controller: SBSDKBarcodeTrackingOverlayController,
                                updateCustomView view: UIView,
                                with item: SBSDKBarcodeTrackingOverlayItem) {
        guard let view = view as? CustomTrackedBarcodeView else { return }
        view.update(with: item, style: style(for: item.barcode))
    }
}
