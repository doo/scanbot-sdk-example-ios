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
    case classicWithFinder
    case classicWithTrackingOverlay
    case scanAndCount
    case barcodeWithTextPattern
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .rtuUI:
            return "RTU UI Barcode Scanner"
        case .classic:
            return "Classic Barcode Scanner"
        case .classicWithFinder:
            return "Classic Barcode Scanner with Finder"
        case .classicWithTrackingOverlay:
            return "Classic Barcode Scanner with Tracking Overlay"
        case .scanAndCount:
            return "Scan and Count"
        case .barcodeWithTextPattern:
            return "Barcode + Text Pattern"
        }
    }
    
    var isReadyToUseUI: Bool {
        switch self {
        case .rtuUI: return true
        default: return false
        }
    }
    
    var shouldPresentModally: Bool {
        return isReadyToUseUI
    }
    
    static var readyToUseUIScanners: [BarcodeScanner] {
        return allCases.filter { $0.isReadyToUseUI }
    }
    
    static var classicScanners: [BarcodeScanner] {
        return allCases.filter { !$0.isReadyToUseUI }
    }
    
    /// Only these examples report their result back into the list of the previous screen.
    var reportsResultToList: Bool {
        switch self {
        case .rtuUI, .classic, .classicWithFinder: return true
        default: return false
        }
    }
}
