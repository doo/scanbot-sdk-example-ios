//
//  ResultHandlingExamples.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 19.11.25.
//

import UIKit
import ScanbotSDK

class BarcodeResultHandlingGeneral {
    
    func handleError(_ error: Error) {
        
        print("Error: \(error.localizedDescription)")
        
        // Cast `Error` to type `SBSDKError` to access underlying SDK properties.
        // We can safely assume that only `SBSDKErrors` are thrown
        let sdkError = error as! SBSDKError
        
        // Use switch to determine the error and handle it according to your use case.
        switch sdkError {
        case .unknownError(let string): return
        case .invalidLicense(let string): return
        case .nullPointer(let string): return
        case .invalidArgument(let string): return
        case .invalidImageRef(let string): return
        case .componentUnavailable(let string):return
        case .illegalState(let string): return
        case .ioError(let string): return
        case .invalidData(let string): return
        case .operationCanceled(let string): return
        case .outOfMemory(let string): return
        case .timeout(let string): return
        default: print("Unknown error code with description: \(sdkError.localizedDescription)")
        }
    }
    
    func checkCanceledError(_ error: Error) {
        
        // We can safely assume that only `SBSDKErrors` are thrown
        let sdkError = error as! SBSDKError
        
        // Check if the error represents a canceled operation.
        if sdkError.isCanceled {
            print("The operation was cancelled before completion or by the user: \(error.localizedDescription)")
        }
    }
    
    func doCatchExample() {
        
        // The image containing a barcode.
        guard let image = UIImage(named: "barcodeImage") else { return }

        do {
            // Create an instance of the scanner.
            let scanner = try SBSDKBarcodeScanner(configuration: .init())
            
            // Create an image ref from UIImage.
            let imageRef = SBSDKImageRef.fromUIImage(image: image)
            
            // Run scanner on the given image.
            let result = try scanner.run(image: imageRef)
        }
        catch {
            print("Error scanning barcode: \(error.localizedDescription)")
        }
    }

    func optionalTryExample() {
        
        // The image containing a barcode.
        guard let image = UIImage(named: "barcodeImage") else { return }
        
        // Create an instance of the scanner.
        let scanner = try? SBSDKBarcodeScanner(configuration: .init())
        
        // Create an image ref from UIImage.
        let imageRef = SBSDKImageRef.fromUIImage(image: image)
        
        // Run scanner on the given image.
        let result = try? scanner?.run(image: imageRef)
        
        if let result {
            // Handle the result.
            
        } else {
            // Handle failure.
            // Note: Here you do not have any information about the error contrary to the `do-catch`
            // as the `error` itself is not available.
        }
    }
}

// RTU-UI
class BarcodeRTUUIResultHandlingExampleViewController: UIViewController {
    
    func startScanning() {
        
        // Present the view controller modally.
        SBSDKUI2BarcodeScannerViewController.present(on: self,
                                                     configuration: .init()) { controller, result, error in
            if let error {
                
                // We can safely assume that only `SBSDKErrors` are thrown.
                let sdkError = error as! SBSDKError
                
                // Check if the error represents a canceled operation.
                if sdkError.isCanceled {
                    print("The operation was cancelled before completion or by the user")
                    
                } else {
                    print("Error scanning barcodes: \(sdkError.localizedDescription)")
                }
                
            } else if let result {
                // Handle the result.
            }
        }
    }
}

// Classic
class BarcodeClassicResultHandlingExampleViewController: UIViewController, SBSDKBarcodeScannerViewControllerDelegate {
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  didScanBarcodes codes: [SBSDKBarcodeItem]) {
        // Handle the result.
    }
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  didFailScanning error: any Error) {
        // Handle the error.
        
        // We can safely assume that only `SBSDKErrors` are thrown.
        let sdkError = error as! SBSDKError
        
        // Check if the error represents a canceled operation.
        if sdkError.isCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } else {
            print("Error scanning barcodes: \(sdkError.localizedDescription)")
        }
    }
}
