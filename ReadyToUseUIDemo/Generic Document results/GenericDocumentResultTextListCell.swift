//
//  GenericDocumentResultTextListCell.swift
//  ReadyToUseUIDemo
//
//  Created by Danil Voitenko on 14.01.22.
//  Copyright © 2022 doo GmbH. All rights reserved.
//

import UIKit

final class GenericDocumentResultTextListCell: UITableViewCell {
    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var valueLabel: UILabel?
    @IBOutlet private var percentageLabel: UILabel?
    
    func configure(title: String, value: String, confidence: Int) {
        titleLabel?.text = title
        valueLabel?.text = value
        percentageLabel?.text = "\(confidence)%"
    }
}
