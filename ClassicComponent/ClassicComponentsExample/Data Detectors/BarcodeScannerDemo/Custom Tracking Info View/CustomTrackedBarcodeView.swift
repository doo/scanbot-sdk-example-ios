//
//  CustomTrackedBarcodeView.swift
//  ClassicComponentsExample
//
//  Created by Rana Sohaib on 17.03.23.
//  Copyright © 2023 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

/// A custom view that the barcode tracking overlay displays for every tracked barcode.
class CustomTrackedBarcodeView: UIView {
    
    @IBOutlet var titleLabel: UILabel!
    
    var barcode: SBSDKBarcodeItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8.0
        backgroundColor = UIColor.clear
    }
    
    static func make(with barcode: SBSDKBarcodeItem) -> CustomTrackedBarcodeView {
        let nib = UINib(nibName: "CustomTrackedBarcodeView", bundle: nil)
        guard let view = nib.instantiate(withOwner: nil).first as? CustomTrackedBarcodeView else {
            fatalError("View is not implemented properly.")
        }
        view.barcode = barcode
        return view
    }
    
    /// Updates the view with the current tracking information and the style of the tracked barcode.
    func update(with item: SBSDKBarcodeTrackingOverlayItem, style: SBSDKBarcodeTrackingOverlayStyle) {
        
        barcode = item.barcode
        isHidden = false
        
        var text = ""
        if style.textDrawingEnabled {
            if let textOverride = style.textOverride {
                text = textOverride
            } else {
                switch style.textFormat {
                case .code:
                    text = item.barcode.textWithExtension
                case .codeAndType:
                    text = String("\(item.barcode.format.name)\n\(item.barcode.displayText)")
                case .none:
                    break
                @unknown default:
                    break
                }
            }
        }
        
        backgroundColor = style.textBackgroundColor.withAlphaComponent(0.2)
        titleLabel.text = text
        titleLabel.font = style.textFont
        titleLabel.textColor = style.textColor
        titleLabel.backgroundColor = style.textBackgroundColor
        titleLabel.isHidden = !style.textDrawingEnabled
        
        let insets = UIEdgeInsets(top: -8, left: -8, bottom: -(8 + 40), right: -8)
        frame = item.barcodeFrame.inset(by: insets)
    }
}
