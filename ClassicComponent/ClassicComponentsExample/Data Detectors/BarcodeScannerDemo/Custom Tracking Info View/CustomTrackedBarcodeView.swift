//
//  CustomTrackedBarcodeView.swift
//  ClassicComponentsExample
//
//  Created by Rana Sohaib on 17.03.23.
//  Copyright © 2023 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class CustomTrackedBarcodeView: UIView, SBSDKTrackedBarcodeInfoViewable {
    
    @IBOutlet var titleLabel: UILabel!

    var barcode: SBSDKBarcodeItem?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8.0
        backgroundColor = UIColor.clear
    }
    
    static func make(withBarcode: SBSDKBarcodeItem) -> ScanbotSDK.SBSDKTrackedBarcodeInfoView {
        let nib = UINib(nibName: "CustomTrackedBarcodeView", bundle: nil)
        guard let view = nib.instantiate(withOwner: nil).first as? CustomTrackedBarcodeView else {
            fatalError("View is not implemented properly.")
        }
        view.barcode = withBarcode
        return view
    }
    
    func update(barcodeFrame: CGRect, 
                isHighlighted isSelected: Bool, 
                textStyle: ScanbotSDK.SBSDKBarcodeTrackedViewTextStyle, 
                polygonStyle: ScanbotSDK.SBSDKBarcodeTrackedViewPolygonStyle) {
        
        guard let code = barcode else {
            isHidden = true
            return
        }
        isHidden = false

        var text = ""
        if textStyle.textDrawingEnabled {
            switch textStyle.trackingOverlayTextFormat {
            case .code:
                text = code.textWithExtension
            case .codeAndType:
                text = String("\(code.format.name)\n\(code.displayText)")
            case .none:
                break
            @unknown default:
                fatalError()
            }
        }
        
        backgroundColor = textStyle.textBackgroundColor.withAlphaComponent(0.2)
        titleLabel.text = text
        titleLabel.font = textStyle.textFont
        titleLabel.textColor = textStyle.textColor
        titleLabel.backgroundColor = textStyle.textBackgroundColor
        titleLabel.isHidden = !textStyle.textDrawingEnabled
        
        let insets = UIEdgeInsets(top: -8, left: -8, bottom: -(8 + 40), right: -8)
        let rect = barcodeFrame.inset(by: insets)
        frame = rect
    }
    
}
