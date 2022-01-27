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
        self.titleLabel?.text = title
        self.valueLabel?.text = value
        self.percentageLabel?.text = "\(confidence)%"
    }
}
