//
//  AdjustableFilterModel.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 15.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

struct AdjustableFilterModel {
    typealias Changehandler = (Float)->()
    
    var name: String
    var maxValue: Float = 1.0
    var minValue: Float = -1.0
    var value: Float = 0.0 {
        didSet {
            value = max(min(value, maxValue), minValue)
            changeHandler(value)
        }
    }
    var changeHandler: Changehandler
}
