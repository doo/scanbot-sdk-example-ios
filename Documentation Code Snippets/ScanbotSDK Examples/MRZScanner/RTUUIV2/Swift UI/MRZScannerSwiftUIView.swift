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
    
    // An optional `SBSDKUI2MRZScannerUIResult` object containing the resulting MRZ of the scanning process.
    @State var scannedMRZ: SBSDKUI2MRZScannerUIResult?
    
    // An optional error object representing any errors that may occur during the scanning process.
    @State var scanError: Error?
    
    var body: some View {
        
        if scannedMRZ == nil && scanError == nil {
            
            // Show the scanner, passing the configuration and handling the result.
            // `SBSDKUI2MRZScannerView`'s initializer now throws (e.g. on an invalid/missing
            // license), so we use `try?` here and show an inline error view on failure.
            if let scannerView = try? SBSDKUI2MRZScannerView(configuration: configuration, completion: { result, error in
                
                scannedMRZ = result
                scanError = error
            }) {
                scannerView
                    .ignoresSafeArea()
            } else {
                Text("Failed to create the MRZ scanner. Please check your license.")
            }
            
        } else if let scannedMRZ {
            // Process and show the scanned MRZ here.
            
            // Cast the resulting generic document to the MRZ model using the `wrap` method.
            if let model = scannedMRZ.mrzDocument?.wrap() as? SBSDKDocumentsModelMRZ {
                
                // Retrieve the values.
                // e.g
                if let birthDate = model.birthDate?.value {
                    Text("Birth date: \(birthDate.text), Confidence: \(birthDate.confidence)")
                }
                if let nationality = model.nationality?.value {
                    Text("Nationality: \(nationality.text), Confidence: \(nationality.confidence)")
                }
            }
            
        } else if let scanError {
            
            // Show error view here.
            Text("Scan error: \(scanError.localizedDescription)")
            
        }
    }
}

#Preview {
    MRZScannerSwiftUIView()
}
