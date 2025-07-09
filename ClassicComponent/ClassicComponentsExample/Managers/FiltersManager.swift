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
    static let filters: [SBSDKImageFilterType] = [
        .none,
        .color,
        .gray,
        .pureGray,
        .binarized,
        .colorDocument,
        .pureBinarized,
        .backgroundClean,
        .blackAndWhite,
        .otsuBinarization,
        .deepBinarization,
        .edgeHighlight,
        .lowLightBinarization,
        .lowLightBinarization2
    ]
    
    static func name(for filter: SBSDKImageFilterType) -> String {
        switch filter {
        case .none:
            return "None"
        case .color:
            return "Color"
        case .gray:
            return "Optimized greyscale"
        case .pureGray:
            return "Pure greyscale"
        case .binarized:
            return "Binarized"
        case .colorDocument:
            return "Color document"
        case .pureBinarized:
            return "Pure binarized"
        case .backgroundClean:
            return "Background clean"
        case .blackAndWhite:
            return "Black & white"
        case .otsuBinarization:
            return "Otsu binarization"
        case .deepBinarization:
            return "Deep binarization"
        case .edgeHighlight:
            return "Edge highlight"
        case .lowLightBinarization:
            return "Low light binarization"
        case .lowLightBinarization2:
            return "Low light binarization 2"
        default: return "UNKNOWN"
        }
    }
}
