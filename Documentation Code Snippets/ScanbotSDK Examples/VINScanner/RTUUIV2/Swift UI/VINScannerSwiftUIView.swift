//
//  VINScannerSwiftUIView.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 05.02.25.
//

import SwiftUI
import ScanbotSDK

struct VINScannerSwiftUIView: View {
    
    // An instance of `SBSDKUI2VINScannerScreenConfiguration` which contains the
    // configuration settings for the VIN scanner.
    let configuration: SBSDKUI2VINScannerScreenConfiguration = {
        
        return SBSDKUI2VINScannerScreenConfiguration()
    }()
    
    // An optional `SBSDKUI2VINScannerUIResult` object containing the resulted
    // VIN of the scanning process.
    @State var scannedVIN: SBSDKUI2VINScannerUIResult?
    
    var body: some View {
        
        // Show the scanner, passing the configuration and handling the result.
        SBSDKUI2VINScannerView(configuration: configuration) { result in
            
            if let result {
                scannedVIN = result
                
            } else {
                
                // Dismiss your view here.
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    VINScannerSwiftUIView()
}
