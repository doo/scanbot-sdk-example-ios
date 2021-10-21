//
//  BarcodeScanner.swift
//  BarcodeScanner
//
//  Created by Danil Voitenko on 20.07.21.
//

import Foundation
import ScanbotSDK

enum BarcodeScanner: Identifiable, CaseIterable {
    case rtuUI
    case classic
    case manuallyComposed
    
    var id: String {
        title.replacingOccurrences(of: " ", with: "")
    }
    
    var title: String {
        switch self {
        case .rtuUI:
            return "RTU UI Barcode Scanner"
        case .classic:
            return "Classic Barcode Scanner"
        case .manuallyComposed:
            return "Manually Built Barcode Scanner"
        }
    }
    
    var shouldPresentModally: Bool {
        switch self {
        case .rtuUI: return true
        case .classic, .manuallyComposed: return false
        }
    }
}
