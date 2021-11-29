//
//  BusinessCardDemoCell.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 26.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit

class BusinessCardDemoCell: UICollectionViewCell {
    var image: UIImage? {
        didSet {
            imageView?.image = image
        }
    }
    
    @IBOutlet private var imageView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView?.image = image
    }
}
