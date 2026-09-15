//
//  DataCaptureContainerView.swift
//  SwiftUIComponentsExample
//

import SwiftUI

struct DataCaptureContainerView: View {
    
    let scanner: DataCaptureScanner
    
    @State private var isScanningEnabled = true
    
    var body: some View {
        scannerView
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle(Text(scanner.title))
            .onAppear { isScanningEnabled = true }
            .onDisappear { isScanningEnabled = false }
    }
    
    @ViewBuilder
    private var scannerView: some View {
        switch scanner {
        case .mrzClassic:
            MRZScannerClassicView(isScanningEnabled: $isScanningEnabled)
        case .mrzRTUUI:
            MRZScannerRTUUIView()
        case .checkClassic:
            CheckScannerClassicView(isScanningEnabled: $isScanningEnabled)
        case .checkRTUUI:
            CheckScannerRTUUIView()
        case .creditCardClassic:
            CreditCardScannerClassicView(isScanningEnabled: $isScanningEnabled)
        case .creditCardRTUUI:
            CreditCardScannerRTUUIView()
        case .vinClassic:
            VINScannerClassicView(isScanningEnabled: $isScanningEnabled)
        case .vinRTUUI:
            VINScannerRTUUIView()
        case .textPatternClassic:
            TextPatternScannerClassicView(isScanningEnabled: $isScanningEnabled)
        case .textPatternRTUUI:
            TextPatternScannerRTUUIView()
        case .medicalCertificateClassic:
            MedicalCertificateScannerClassicView(isScanningEnabled: $isScanningEnabled)
        case .documentDataExtractorClassic:
            DocumentDataExtractorClassicView(isScanningEnabled: $isScanningEnabled)
        case .documentDataExtractorRTUUI,
             .europeanHealthInsuranceCardRTUUI,
             .germanIDCardRTUUI,
             .europeanDriverLicenseRTUUI:
            DocumentDataExtractorRTUUIView(acceptedDocumentTypes: scanner.acceptedDocumentTypes,
                                           title: scanner.title)
        }
    }
}
