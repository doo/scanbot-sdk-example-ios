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
    
    var body: some View {
        
        // Show the scanner, passing the configuration and handling the result.
        SBSDKUI2TextPatternScannerView(configuration: configuration) { result in
            
            if let result {
                scannedTextPattern = result
                
            } else {
                
                // Dismiss your view here.
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    TextPatternScannerSwiftUIView()
}
