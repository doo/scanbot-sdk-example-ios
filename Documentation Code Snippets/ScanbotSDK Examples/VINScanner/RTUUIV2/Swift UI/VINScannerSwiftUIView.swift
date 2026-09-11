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
    
    // An optional `SBSDKUI2VINScannerUIResult` object containing the resulting
    // VIN of the scanning process.
    @State var scannedVIN: SBSDKUI2VINScannerUIResult?
    
    // An optional error object representing any errors that may occur during the scanning process.
    @State var scanError: Error?
    
    var body: some View {
        
        if scannedVIN == nil, scanError == nil {
            
            // Show the scanner, passing the configuration and handling the result.
            // `SBSDKUI2VINScannerView`'s initializer now throws (e.g. on an invalid/missing
            // license), so we use `try?` here and show an inline error view on failure.
            if let scannerView = try? SBSDKUI2VINScannerView(configuration: configuration, completion: { result, error in
                
                scannedVIN = result
                scanError = error
            }) {
                scannerView
                    .ignoresSafeArea()
            } else {
                Text("Failed to create the VIN scanner. Please check your license.")
            }
            
        } else if let scannedVIN {
            
            // Process and show the scanned VIN here.
            Text("Scanned VIN Text: \(scannedVIN.textResult)")
            Text("Scanned VIN Barcode Status: \(barcodeStatusString(scannedVIN.barcodeResult.status))")
            Text("Barcode extracted VIN: \(scannedVIN.barcodeResult.extractedVIN)")
            
        } else if let scanError {
            
            // Show error view here.
            Text("Scan error: \(scanError.localizedDescription)")
        }
    }
    
    func barcodeStatusString(_ status: SBSDKVINBarcodeExtractionStatus) -> String {
        switch status {
        case .success: return "Success"
        case .barcodeWithoutVin: return "Barcode without VIN"
        case .noBarcodeFound: return "No barcode found"
        case .barcodeExtractionDisabled: return "Barcode extraction disabled"
        default: return "Unknown status"
        }
    }
}

#Preview {
    VINScannerSwiftUIView()
}
