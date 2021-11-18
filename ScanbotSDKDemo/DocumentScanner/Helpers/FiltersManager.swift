//
//  FiltersManager.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 17.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

struct FilterManager {
    static let filters: [SBSDKImageFilterType] = [
        SBSDKImageFilterTypeNone,
        SBSDKImageFilterTypeColor,
        SBSDKImageFilterTypeGray,
        SBSDKImageFilterTypePureGray,
        SBSDKImageFilterTypeBinarized,
        SBSDKImageFilterTypeColorDocument,
        SBSDKImageFilterTypePureBinarized,
        SBSDKImageFilterTypeBackgroundClean,
        SBSDKImageFilterTypeBlackAndWhite,
        SBSDKImageFilterTypeOtsuBinarization,
        SBSDKImageFilterTypeDeepBinarization,
        SBSDKImageFilterTypeEdgeHighlight,
        SBSDKImageFilterTypeLowLightBinarization,
        SBSDKImageFilterTypeLowLightBinarization2
    ]
    
    static func name(for filter: SBSDKImageFilterType) -> String {
        switch filter {
        case SBSDKImageFilterTypeNone:
            return "None"
        case SBSDKImageFilterTypeColor:
            return "Color"
        case SBSDKImageFilterTypeGray:
            return "Optimized greyscale"
        case SBSDKImageFilterTypePureGray:
            return "Pure greyscale"
        case SBSDKImageFilterTypeBinarized:
            return "Binarized"
        case SBSDKImageFilterTypeColorDocument:
            return "Color document"
        case SBSDKImageFilterTypePureBinarized:
            return "Pure binarized"
        case SBSDKImageFilterTypeBackgroundClean:
            return "Background clean"
        case SBSDKImageFilterTypeBlackAndWhite:
            return "Black & white"
        case SBSDKImageFilterTypeOtsuBinarization:
            return "Otsu binarization"
        case SBSDKImageFilterTypeDeepBinarization:
            return "Deep binarization"
        case SBSDKImageFilterTypeEdgeHighlight:
            return "Edge highlight"
        case SBSDKImageFilterTypeLowLightBinarization:
            return "Low light binarization"
        case SBSDKImageFilterTypeLowLightBinarization2:
            return "Low light binarization 2"
        default: return "UNKNOWN"
        }
    }
}
