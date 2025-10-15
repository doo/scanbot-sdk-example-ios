//
//  DocumentDateExtractorResultImageListCell.swift
//  DataCaptureRTUUIExample
//
//  Created by Danil Voitenko on 14.01.22.
//  Copyright © 2022 doo GmbH. All rights reserved.
//

import Foundation
import UIKit
import ScanbotSDK

final class DocumentDateExtractorResultImageListCell: UITableViewCell {
    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var resultImageView: UIImageView?
    
    func configure(title: String?, image: SBSDKImageRef?) {
        titleLabel?.text = title
        resultImageView?.image = try? image?.toUIImage()
    }
}
