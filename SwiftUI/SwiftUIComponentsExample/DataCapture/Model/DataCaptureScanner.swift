//
//  DataCaptureScanner.swift
//  SwiftUIComponentsExample
//
//  All data capture examples of the app, both classic and ready-to-use UI.
//

import ScanbotSDK

enum DataCaptureScanner: String, Identifiable, CaseIterable {
    
    case mrzClassic
    case mrzRTUUI
    case checkClassic
    case checkRTUUI
    case creditCardClassic
    case creditCardRTUUI
    case vinClassic
    case vinRTUUI
    case textPatternClassic
    case textPatternRTUUI
    case medicalCertificateClassic
    case documentDataExtractorClassic
    case documentDataExtractorRTUUI
    case europeanHealthInsuranceCardRTUUI
    case germanIDCardRTUUI
    case europeanDriverLicenseRTUUI
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .mrzClassic: return "MRZ Scanner"
        case .mrzRTUUI: return "MRZ Scanner"
        case .checkClassic: return "Check Scanner"
        case .checkRTUUI: return "Check Scanner"
        case .creditCardClassic: return "Credit Card Scanner"
        case .creditCardRTUUI: return "Credit Card Scanner"
        case .vinClassic: return "VIN Scanner"
        case .vinRTUUI: return "VIN Scanner"
        case .textPatternClassic: return "Text Pattern Scanner"
        case .textPatternRTUUI: return "Text Pattern Scanner"
        case .medicalCertificateClassic: return "Medical Certificate Scanner"
        case .documentDataExtractorClassic: return "Document Data Extractor"
        case .documentDataExtractorRTUUI: return "Document Data Extractor"
        case .europeanHealthInsuranceCardRTUUI: return "European Health Insurance Card"
        case .germanIDCardRTUUI: return "German ID Card"
        case .europeanDriverLicenseRTUUI: return "European Driver's License"
        }
    }
    
    var isReadyToUseUI: Bool {
        switch self {
        case .mrzRTUUI, .checkRTUUI, .creditCardRTUUI, .vinRTUUI, .textPatternRTUUI,
             .documentDataExtractorRTUUI, .europeanHealthInsuranceCardRTUUI,
             .germanIDCardRTUUI, .europeanDriverLicenseRTUUI:
            return true
        case .mrzClassic, .checkClassic, .creditCardClassic, .vinClassic,
             .textPatternClassic, .medicalCertificateClassic, .documentDataExtractorClassic:
            return false
        }
    }
    
    /// Ready-to-use UI components bring their own full screen UI and are therefore presented modally.
    var shouldPresentModally: Bool {
        return isReadyToUseUI
    }
    
    /// The document types the document data extractor accepts. An empty list accepts all known types.
    var acceptedDocumentTypes: [String] {
        switch self {
        case .europeanHealthInsuranceCardRTUUI:
            return [SBSDKDocumentsModelConstants.europeanHealthInsuranceCardDocumentType]
        case .germanIDCardRTUUI:
            return [SBSDKDocumentsModelConstants.deIdCardBackDocumentType,
                    SBSDKDocumentsModelConstants.deIdCardFrontDocumentType]
        case .europeanDriverLicenseRTUUI:
            return [SBSDKDocumentsModelConstants.europeanDriverLicenseBackDocumentType,
                    SBSDKDocumentsModelConstants.europeanDriverLicenseFrontDocumentType]
        default:
            return []
        }
    }
    
    static var classicScanners: [DataCaptureScanner] {
        return allCases.filter { !$0.isReadyToUseUI }
    }
    
    static var readyToUseUIScanners: [DataCaptureScanner] {
        return allCases.filter { $0.isReadyToUseUI }
    }
}
