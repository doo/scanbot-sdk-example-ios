//
//  FiltersManager.swift
//  ClassicComponentsExample
//
//  Created by Danil Voitenko on 17.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

struct FilterManager {
    static let filters: [SBSDKParametricFilter] = [
        .brightnessFilter(),
        .colorDocumentFilter(),
        .contrastFilter(),
        .customBinarizationFilter(),
        .grayscaleFilter(),
        .scanbotBinarizationFilter(),
        .whiteBlackPointFilter(),
    ]
    
    static func name(for filter: SBSDKParametricFilter) -> String {
        switch filter {
        case .brightnessFilter():
            return "Brightness"
        case .colorDocumentFilter():
            return "Color"
        case .contrastFilter():
            return "Contrast"
        case .customBinarizationFilter():
            return "Custom binarization"
        case .grayscaleFilter():
            return "Gray Scale"
        case .scanbotBinarizationFilter():
            return "Scanbot binarization"
        case .whiteBlackPointFilter():
            return "Black & white"
        default: return "UNKNOWN"
        }
    }
}
