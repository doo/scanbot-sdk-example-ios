//
//  DocumentMultiPageUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 25.07.24.
//

import Foundation
import ScanbotSDK

class DocumentMultiPageUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        Task {
            await self.startScanning()
        }
    }
    
    func startScanning() async {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2DocumentScanningFlow()
        
        // Set the page limit to 0, to disable the limit, or set it to the number of pages to be scanned.
        configuration.outputSettings.pagesScanLimit = 0
        
        // Disable the acknowledgment screen.
        configuration.screens.camera.acknowledgement.acknowledgementMode = .none
        
        // Present the view controller modally.
        do {
            let result = try await SBSDKUI2DocumentScannerController.present(on: self, configuration: configuration)
            
            // Handle the result.
            print(result.uuid)
            print(result.pageCount)
            print(result.documentImageSizeLimit)
            print(result.pdfURI)
            print(result.tiffURI)
            print(result.creationDate)
            
            // Check out other available properties in `SBSDKScannedDocument`.
            
            result.pages.forEach { scannedPage in
                
                print(scannedPage.uuid)
                print(scannedPage.documentDetectionStatus)
                print(scannedPage.polygon)
                print(scannedPage.source)
                
                let originalImage = scannedPage.originalImage
                let originalImageURI = scannedPage.originalImageURI
                
                let documentImage = scannedPage.documentImage
                let documentImageURI = scannedPage.documentImageURI
                
                let documentImagePreview = scannedPage.documentImagePreview
                let documentImagePreviewURI = scannedPage.documentImagePreviewURI
                
                if let documentQuality = scannedPage.documentQuality {
                    switch documentQuality {
                    case .veryPoor: print("veryPoor")
                    case .poor: print("poor")
                    case .reasonable: print("reasonable")
                    case .good: print("good")
                    case .excellent: print("excellent")
                    default: print("unknown")
                    }
                }
                // Check out other available properties in `SBSDKScannedPage`
            }
        }
        catch SBSDKError.operationCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } catch {
            // Any other error
            print("Error scanning document: \(error.localizedDescription)")
        }
    }
}
