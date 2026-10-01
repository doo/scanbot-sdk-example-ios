//
//  VINLaunchingUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct VINLaunchingUI2SwiftUIView: View {
    
    @State private var configuration: SBSDKUI2VINScannerScreenConfiguration = {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2VINScannerScreenConfiguration()

        
        return configuration
    }()
    
    @State private var result: SBSDKUI2VINScannerUIResult?
    @State private var scanError: Error?
    
    var body: some View {
        
        if result == nil && scanError == nil {
            
            // Create and present the scanner view.
            SBSDKUI2VINScannerView(configuration: configuration, completion: { result, error in
                
                if let result {

                    // Process the result as needed.
                            
                }
                
                self.result = result
                self.scanError = error
            })
                    .ignoresSafeArea()

            
        } else if let scanError {
            
            switch scanError {
            case SBSDKError.operationCanceled:
                Text("The operation was cancelled before completion or by the user")
            default:
                // Any other error
                Text("Error scanning VIN: \(scanError.localizedDescription)")
            }
            
        } else {
            EmptyView()
        }
    }
}

#Preview {
    VINLaunchingUI2SwiftUIView()
}
