//
//  MRZScannerSwiftUIView.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 23.01.25.
//

import SwiftUI
import ScanbotSDK

struct MRZScannerSwiftUIView: View {
    
    // An instance of `SBSDKUI2MRZScannerScreenConfiguration` which contains the configuration settings for the MRZ scanner.
    let configuration: SBSDKUI2MRZScannerScreenConfiguration = {
        
        return SBSDKUI2MRZScannerScreenConfiguration()
    }()
    
    // An optional `SBSDKUI2MRZScannerUIResult` object containing the resulted MRZ of the scanning process.
    @State var scannedMRZ: SBSDKUI2MRZScannerUIResult?
    
    var body: some View {
        
        // Show the scanner, passing the configuration and handling the result.
        SBSDKUI2MRZScannerView(configuration: configuration) { result in
            
            if let result {
                scannedMRZ = result
                
                // Cast the resulted generic document to the MRZ model using the `wrap` method.
                if let model = result.mrzDocument?.wrap() as? SBSDKDocumentsModelMRZ {
                    
                    // Retrieve the values.
                    // e.g
                    if let birthDate = model.birthDate?.value {
                        print("Birth date: \(birthDate.text), Confidence: \(birthDate.confidence)")
                    }
                    if let nationality = model.nationality?.value {
                        print("Nationality: \(nationality.text), Confidence: \(nationality.confidence)")
                    }
                }
                
            } else {
                
                // Dismiss your view here.
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    MRZScannerSwiftUIView()
}
