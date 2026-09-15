//
//  DocumentScanner.swift
//  SwiftUIComponentsExample
//
//  Created by Rana Sohaib on 23.08.24.
//

import ScanbotSDK

enum DocumentScanner: Identifiable, CaseIterable {
    case rtuUISinglePage
    case rtuUISinglePageWithFinder
    case rtuUIMultiPage
    case classic
    case classicWithFinder
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .rtuUISinglePage:
            return "RTU UI Single-Page Scanning"
        case .rtuUISinglePageWithFinder:
            return "RTU UI Single-Page Scanning with Finder"
        case .rtuUIMultiPage:
            return "RTU UI Multiple-Page Scanning"
        case .classic:
            return "Classic Document Scanner"
        case .classicWithFinder:
            return "Classic Document Scanner with A4 Finder"
        }
    }
    
    var isReadyToUseUI: Bool {
        switch self {
        case .rtuUISinglePage, .rtuUISinglePageWithFinder, .rtuUIMultiPage:
            return true
        case .classic, .classicWithFinder:
            return false
        }
    }
    
    var shouldPresentModally: Bool {
        return isReadyToUseUI
    }
    
    static var readyToUseUIScanners: [DocumentScanner] {
        return allCases.filter { $0.isReadyToUseUI }
    }
    
    static var classicScanners: [DocumentScanner] {
        return allCases.filter { !$0.isReadyToUseUI }
    }
}

/// The configuration variants of the ready-to-use UI document scanner.
enum DocumentScanningFlowVariant {
    case singlePage
    case singlePageWithFinder
    case multiplePage
}

extension DocumentScanner {
    
    var flowVariant: DocumentScanningFlowVariant {
        switch self {
        case .rtuUISinglePageWithFinder: return .singlePageWithFinder
        case .rtuUIMultiPage: return .multiplePage
        default: return .singlePage
        }
    }
}
