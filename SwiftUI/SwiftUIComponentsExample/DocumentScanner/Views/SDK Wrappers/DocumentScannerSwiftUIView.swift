//
//  DocumentScannerSwiftUIView.swift
//  SwiftUIComponentsExample
//
//  Created by Rana Sohaib on 27.08.24.
//

import SwiftUI
import ScanbotSDK

struct DocumentScannerSwiftUIView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var scanningResult: DocumentScanningResult
    
    @State private var document: SBSDKScannedDocument? = nil

    var body: some View {
        
        SBSDKUI2DocumentScannerView(configuration: SBSDKUI2DocumentScanningFlow()) { scannedDocument, error in
            
            if let scannedDocument {
                scanningResult = DocumentScanningResult(scannedDocument: scannedDocument)
            }
            
            presentationMode.wrappedValue.dismiss()
        }
    }
}
