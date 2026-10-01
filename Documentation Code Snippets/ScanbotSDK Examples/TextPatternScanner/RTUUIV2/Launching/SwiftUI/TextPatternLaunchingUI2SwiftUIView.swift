//
//  TextPatternLaunchingUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct TextPatternLaunchingUI2SwiftUIView: View {
    
    @State private var configuration: SBSDKUI2TextPatternScannerScreenConfiguration = {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2TextPatternScannerScreenConfiguration()
        
        return configuration
    }()
    
    @State private var scanError: Error?

    var body: some View {
        
        if let scanError {

            if (scanError as? SBSDKError)?.isCanceled == true {
                Text("The operation was cancelled before completion or by the user")
            } else {
                Text("Error scanning Text Pattern: \(scanError.localizedDescription)")
            }

        } else {
            SBSDKUI2TextPatternScannerView(configuration: configuration, completion: { result, error in
            if let result {
                
                // Process the result as needed.
            }
            
            if let error {
                if case SBSDKError.operationCanceled = error {
                    print("The operation was cancelled before completion or by the user")
                } else {
                    // Any other error
                    print("Error scanning Text Pattern: \(error.localizedDescription)")
                }
                scanError = error
            }
        })
                .ignoresSafeArea()
        }
    }
}

#Preview {
    TextPatternLaunchingUI2SwiftUIView()
}
