//
//  ResultHandlingExamples.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 19.11.25.
//

import UIKit
import ScanbotSDK

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

// MARK: Non-UI Components Result Handling

// Check
func doCatchCheckExample() {
    
    // The image containing a check.
    guard let image = UIImage(named: "checkImage") else { return }

    do {
        // Create an instance of the scanner.
        let scanner = try SBSDKCheckScanner(configuration: .init())
        
        // Create an image ref from UIImage.
        let imageRef = SBSDKImageRef.fromUIImage(image: image)
        
        // Run scanner on the given image.
        let result = try scanner.run(image: imageRef)
    }
    catch {
        print("Error scanning check: \(error.localizedDescription)")
    }
}

func optionalTryCheckExample() {
    
    // The image containing a check.
    guard let image = UIImage(named: "checkImage") else { return }
    
    // Create an instance of the scanner.
    let scanner = try? SBSDKCheckScanner(configuration: .init())
    
    // Create an image ref from UIImage.
    let imageRef = SBSDKImageRef.fromUIImage(image: image)
    
    // Run scanner on the given image.
    let result = try? scanner?.run(image: imageRef)
    
    if let result {
        
        // Handle the result.
        // e.g get the cropped image.
        let croppedImage = try? result.croppedImage?.toUIImage()
        
    } else {
        // Handle failure.
        // Note: Here you do not have any information about the error contrary to the `do-catch`
        // as the `error` itself is not available.
    }
}

// Document
func doCatchDocumentExample() {
    
    // The image containing a document.
    guard let image = UIImage(named: "documentImage") else { return }

    do {
        // Create an instance of the scanner.
        let scanner = try SBSDKDocumentScanner(configuration: .init())
        
        // Create an image ref from UIImage.
        let imageRef = SBSDKImageRef.fromUIImage(image: image)
        
        // Run scanner on the given image.
        let result = try scanner.run(image: imageRef)
    }
    catch {
        print("Error scanning a document: \(error.localizedDescription)")
    }
}

func optionalTryDocumentExample() {
    
    // The image containing a document.
    guard let image = UIImage(named: "documentImage") else { return }
    
    // Create an instance of the scanner.
    let scanner = try? SBSDKDocumentScanner(configuration: .init())
    
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

// MARK: UI Components Result Handling

// Check
class CheckRTUUIResultHandlingExampleViewController: UIViewController {
    
    func startScanning() {
        
        // Present the view controller modally.
        SBSDKUI2CheckScannerViewController.present(on: self,
                                                   configuration: .init()) { controller, result, error in
            if let error {
                
                // We can safely assume that only `SBSDKErrors` are thrown.
                let sdkError = error as! SBSDKError
                
                // Check if the error represents a canceled operation.
                if sdkError.isCanceled {
                    print("The operation was cancelled before completion or by the user")
                    
                } else {
                    print("Error scanning check: \(sdkError.localizedDescription)")
                }
                
            } else if let result {
                // Handle the result.
            }
        }
    }
}

class CheckClassicResultHandlingExampleViewController: UIViewController, SBSDKCheckScannerViewControllerDelegate {
    
    func checkScannerViewController(_ controller: SBSDKCheckScannerViewController,
                                    didScanCheck result: SBSDKCheckScanningResult,
                                    isHighRes: Bool) {
        // Handle the result.
    }
    
    func checkScannerViewController(_ controller: SBSDKCheckScannerViewController,
                                    didFailScanning error: any Error) {
        // Handle the error.
        
        // We can safely assume that only `SBSDKErrors` are thrown.
        let sdkError = error as! SBSDKError
        
        // Check if the error represents a canceled operation.
        if sdkError.isCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } else {
            print("Error scanning check: \(sdkError.localizedDescription)")
        }
    }
}

// Document
class DocumentRTUUIResultHandlingExampleViewController: UIViewController {
    
    func startScanning() {
        
        // Present the view controller modally.
        do {
            let controller = try SBSDKUI2DocumentScannerController.present(on: self,
                                                                           configuration: .init())
            { controller, document, error in
                
                // Completion handler to process the result.
                
                if let document {
                    // Handle the document.
                    
                } else if let error {
                    
                    // We can safely assume that only `SBSDKErrors` are thrown.
                    let sdkError = error as! SBSDKError
                    
                    // Check if the error represents a canceled operation.
                    if sdkError.isCanceled {
                        print("The operation was cancelled before completion or by the user")
                        
                    } else {
                        print("Error scanning document: \(sdkError.localizedDescription)")
                    }
                }
            }
        }
        catch {
            print("Error while presenting the document scanner: \(error.localizedDescription)")
        }
    }
}

class DocumentClassicResultHandlingExampleViewController: UIViewController, SBSDKDocumentScannerViewControllerDelegate {
    
    func documentScannerViewController(_ controller: SBSDKDocumentScannerViewController,
                                       didSnapDocumentImage documentImage: SBSDKImageRef,
                                       on originalImage: SBSDKImageRef,
                                       with result: SBSDKDocumentDetectionResult?,
                                       autoSnapped: Bool) {
        // Handle the result.
    }
    
    func documentScannerViewController(_ controller: SBSDKDocumentScannerViewController,
                                       didFailScanning error: any Error) {
        // Handle the error.
        
        // We can safely assume that only `SBSDKErrors` are thrown.
        let sdkError = error as! SBSDKError
        
        // Check if the error represents a canceled operation.
        if sdkError.isCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } else {
            print("Error scanning document: \(sdkError.localizedDescription)")
        }
    }
}
