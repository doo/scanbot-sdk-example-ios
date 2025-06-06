//
//  DocumentScannerContainerView.swift
//  SwiftUIComponentsExample
//
//  Created by Rana Sohaib on 23.08.24.
//

import Foundation
import SwiftUI

import ScanbotSDK

struct DocumentScannerContainerView: View {

    private let scanner: DocumentScanner

    @Binding private var scanningResult: DocumentScanningResult
    @State private var isScanningEnabled = true
    
    init(scanner: DocumentScanner, scanningResult: Binding<DocumentScanningResult>) {
        self.scanner = scanner
        _scanningResult = scanningResult
    }

    var body: some View {
        viewForScanner(scanner)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle(Text(scanner.title))
            .onAppear { self.isScanningEnabled = true }
            .onDisappear { self.isScanningEnabled = false }
    }
    
    @ViewBuilder
    private func viewForScanner(_ scanner: DocumentScanner) -> some View {
        Group {
            switch scanner {
            case .rtuUI:
                DocumentScannerRTUUIView(scanningResult: $scanningResult)
            case .classic:
                DocumentScannerClassicView(scanningResult: $scanningResult,
                                           isScanningEnabled: $isScanningEnabled)
            case .swiftUI:
                DocumentScannerSwiftUIView(scanningResult: $scanningResult)
            }
        }
    }
}

struct DocumentScannerContainerView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentScannerContainerView(scanner: .rtuUI, 
                                     scanningResult: .constant(DocumentScanningResult(scannedDocument: SBSDKScannedDocument())))
    }
}
