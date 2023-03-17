//
//  BarcodeCustomCell.swift
//  ScanbotSDKDemo
//
//  Created by Rana Sohaib on 17.03.23.
//  Copyright © 2023 doo GmbH. All rights reserved.
//

import UIKit

class BarcodeCustomCell: UICollectionViewCell {
    @IBOutlet var cellBGView: UIView!
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellBGView.layer.cornerRadius = 8.0
    }
}
