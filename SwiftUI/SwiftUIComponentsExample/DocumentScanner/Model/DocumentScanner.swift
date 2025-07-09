//
//  DocumentScanner.swift
//  SwiftUIComponentsExample
//
//  Created by Rana Sohaib on 23.08.24.
//

import ScanbotSDK

enum DocumentScanner: Identifiable, CaseIterable {
    case rtuUI
    case classic
    case swiftUI
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .rtuUI:
            return "RTU UI Document Scanner"
        case .classic:
            return "Classic Document Scanner"
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
