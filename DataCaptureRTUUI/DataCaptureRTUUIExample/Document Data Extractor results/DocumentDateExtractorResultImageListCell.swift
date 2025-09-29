//
//  DocumentDateExtractorResultImageListCell.swift
//  DataCaptureRTUUIExample
//
//  Created by Danil Voitenko on 14.01.22.
//  Copyright © 2022 doo GmbH. All rights reserved.
//

import Foundation
import UIKit

final class DocumentDateExtractorResultImageListCell: UITableViewCell {
    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var resultImageView: UIImageView?
    
    func configure(title: String?, image: UIImage?) {
        titleLabel?.text = title
        resultImageView?.image = image
    }
}
