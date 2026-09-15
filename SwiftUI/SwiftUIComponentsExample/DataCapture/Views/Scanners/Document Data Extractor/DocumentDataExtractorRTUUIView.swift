//
//  DocumentDataExtractorRTUUIView.swift
//  SwiftUIComponentsExample
//

import SwiftUI
import ScanbotSDK

/// Shows the ready-to-use UI document data extractor using the native SwiftUI component
/// `SBSDKUI2DocumentDataExtractorView`. Restricting the accepted document types turns the
/// generic extractor into a scanner for a specific document, e.g. an ID card.
struct DocumentDataExtractorRTUUIView: View {
    
    let acceptedDocumentTypes: [String]
    let title: String
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var scanner: SBSDKUI2DocumentDataExtractorView?
    @StateObject private var state = ScannerSessionState()
    
    var body: some View {
        Group {
            if let scanner {
                scanner
            } else {
                Color.black
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: createScannerIfNeeded)
        .scannerSession(state)
    }
    
    private func createScannerIfNeeded() {
        guard scanner == nil else { return }
        do {
            scanner = try SBSDKUI2DocumentDataExtractorView(configuration: configuration(), completion: handle)
        } catch {
            state.present(error: error)
        }
    }
    
    private func configuration() -> SBSDKUI2DocumentDataExtractorScreenConfiguration {
        let configuration = SBSDKUI2DocumentDataExtractorScreenConfiguration()
        if !acceptedDocumentTypes.isEmpty {
            let element = SBSDKDocumentDataExtractorCommonConfiguration(acceptedDocumentTypes: acceptedDocumentTypes)
            configuration.scannerConfiguration = SBSDKDocumentDataExtractorConfiguration(configurations: [element])
        }
        return configuration
    }
    
    private func handle(result: SBSDKUI2DocumentDataExtractorUIResult?, error: Error?) {
        if let result {
            state.present(ScanResult(title: title,
                                     document: result.document,
                                     images: [result.croppedImage],
                                     extraFields: [ScanResultField(name: "Status",
                                                                   value: result.recognitionStatus.displayText)]))
        } else if let error {
            state.present(error: error)
        }
        presentationMode.wrappedValue.dismiss()
    }
}
