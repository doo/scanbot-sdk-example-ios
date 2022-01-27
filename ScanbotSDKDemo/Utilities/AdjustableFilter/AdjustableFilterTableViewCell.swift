//
//  AdjustableFilterTableViewCell.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 15.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit

final class AdjustableFilterTableViewCell: UITableViewCell {
    
    @IBOutlet private var label: UILabel?
    @IBOutlet private var slider: UISlider?
    
    var filterModel: AdjustableFilterModel? {
        didSet {
            guard let filterModel = filterModel else { return }
            label?.text = filterModel.name
            slider?.minimumValue = filterModel.minValue
            slider?.maximumValue = filterModel.maxValue
            slider?.value = filterModel.value
        }
    }
    
    @IBAction private func sliderChanged(_ sender: UISlider) {
        filterModel?.value = sender.value
    }
    
    @IBAction private func resetButtonPressed(_ sender: Any) {
        filterModel?.value = 0
        slider?.value = 0
    }
}
