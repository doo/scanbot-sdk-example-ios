//
//  ReviewDocumentsCollectionViewCell.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 05.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class ReviewDocumentsCollectionViewCell: UICollectionViewCell {
    @IBOutlet var previewImageView: UIImageView?
    @IBOutlet private var highlightView: UIView?
    @IBOutlet private var infoLabel: UILabel!
    
    var infoLabelText: String? {
        didSet {
            infoLabel?.text = infoLabelText
            infoLabel?.isHidden = (infoLabelText?.count ?? 0) == 0
        }
    }
    
    override var isHighlighted: Bool {
        get { return super.isHighlighted }
        set {
            layoutHighlightView()
            super.isHighlighted = newValue
            UIView.animate(withDuration: 0.01,
                           delay: 0.0,
                           options: [.allowUserInteraction, .beginFromCurrentState, .curveEaseInOut],
                           animations: { self.highlightView?.alpha = newValue ? 1.0 : 0.0 },
                           completion: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        infoLabel.clipsToBounds = true
        infoLabel.layer.cornerRadius = 8.0
        infoLabel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutHighlightView()
    }
    
    private func layoutHighlightView() {
        highlightView?.frame = highlightFrame
    }
    
    private var highlightFrame: CGRect {
        guard let imageView = previewImageView else { return .zero }
        guard let image = imageView.image else { return imageView.frame }
        
        let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        switch imageView.contentMode {
        case .scaleAspectFit:
            return RectFitInRect(imageRect, imageView.frame)
        case .center:
            var centerRect = imageRect
            centerRect.size.width = min(centerRect.size.width, imageView.frame.size.width)
            centerRect.size.height = min(centerRect.size.height, imageView.frame.size.height)
            return RectCenterInRect(centerRect, imageView.frame)
        default:
            return imageView.frame
        }
    }
}
