//
//  FilterTableViewCell.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 15.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit

class SFilterTableViewCell: UITableViewCell {
    var filterModel: SFilterModel? {
        didSet {
            guard let filterModel = filterModel else { return }
            label?.text = filterModel.name
            slider?.minimumValue = filterModel.minValue
            slider?.maximumValue = filterModel.maxValue
            slider?.value = filterModel.value
        }
    }
    
    @IBOutlet private var label: UILabel?
    @IBOutlet private var slider: UISlider?
}
