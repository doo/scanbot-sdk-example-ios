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
    case swiftUI
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .rtuUI:
            return "RTU UI Barcode Scanner"
        case .classic:
            return "Classic Barcode Scanner"
        case .swiftUI:
            return "Swift UI component"
        }
    }
    
    var shouldPresentModally: Bool {
        switch self {
        case .rtuUI, .swiftUI: return true
        case .classic: return false
        }
    }
}
