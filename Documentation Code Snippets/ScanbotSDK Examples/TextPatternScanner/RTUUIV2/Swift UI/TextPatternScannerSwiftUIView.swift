//
//  TextPatternScannerSwiftUIView.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 05.02.25.
//

import SwiftUI
import ScanbotSDK

struct TextPatternScannerSwiftUIView: View {
    
    // An instance of `SBSDKUI2TextPatternScannerScreenConfiguration` which contains the
    // configuration settings for the Text Pattern scanner.
    let configuration: SBSDKUI2TextPatternScannerScreenConfiguration = {
        
        return SBSDKUI2TextPatternScannerScreenConfiguration()
    }()
    
    // An optional `SBSDKUI2TextPatternScannerUIResult` object containing the resulted
    // text pattern of the scanning process.
    @State var scannedTextPattern: SBSDKUI2TextPatternScannerUIResult?
    
    // An optional error object representing any errors that may occur during the scanning process.
    @State var scanError: Error?
    
    var body: some View {
        
        if let scannedTextPattern {
            
            // Process and show the scanned text pattern here.
            Text("Text scanned: \(scannedTextPattern.rawText) with confidence: \(scannedTextPattern.confidence)")
            
        } else if let scanError {
            
            // Show error view here.
            Text("Scan error: \(scanError.localizedDescription)")
            
        } else {
            
            // Show the scanner, passing the configuration and handling the result.
            SBSDKUI2TextPatternScannerView(configuration: configuration) { result, error in
                
                scannedTextPattern = result
                scanError = error
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    TextPatternScannerSwiftUIView()
}
