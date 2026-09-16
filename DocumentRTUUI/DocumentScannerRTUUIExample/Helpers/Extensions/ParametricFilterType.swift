//
//  ParametricFilterType.swift
//  DocumentScannerRTUUIExample
//
//  Created by Rana Sohaib on 24.08.23.
//

import ScanbotSDK

enum ParametricFilterType: CaseIterable {
    
    case binarization, customBinarization, colorDocument, shadowRemoval, brightness, contrast, grayscale, whiteBlackPoint, none
    
    var name: String {
        switch self {
        case .binarization:
            return "Scanbot Binarization Filter"
        case .customBinarization:
            return "Custom Binarization Filter"
        case .colorDocument:
            return "Color Document Filter"
        case .brightness:
            return "Brightness Filter"
        case .contrast:
            return "Contrast Filter"
        case .grayscale:
            return "Grayscale Filter"
        case .whiteBlackPoint:
            return "White Black Point Filter"
        case .shadowRemoval:
            return "Color Document Shadow Removal"
        case .none:
            return "No Filter"
        }
    }
}
