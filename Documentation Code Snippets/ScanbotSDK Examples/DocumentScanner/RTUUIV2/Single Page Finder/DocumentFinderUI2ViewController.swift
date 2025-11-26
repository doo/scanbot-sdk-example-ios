//
//  DocumentFinderUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 16.07.24.
//

import Foundation
import ScanbotSDK

class DocumentFinderUI2ViewController: UIViewController {
    
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
        
        // Set the visibility of the view finder.
        configuration.screens.camera.viewFinder.visible = true
        
        // Create the instance of the style, either `SBSDKUI2FinderCorneredStyle` or `SBSDKUI2FinderStrokedStyle`.
        let style = SBSDKUI2FinderCorneredStyle(strokeColor: SBSDKUI2Color(colorString: "#FFFFFFFF"),
                                                strokeWidth: 3.0,
                                                cornerRadius: 10.0)
        
        // Set the configured style.
        configuration.screens.camera.viewFinder.style = style
        
        // Set the desired aspect ratio of the view finder.
        configuration.screens.camera.viewFinder.aspectRatio = SBSDKAspectRatio(width: 4.0, height: 5.0)
        
        // Set the overlay color.
        configuration.screens.camera.viewFinder.overlayColor = SBSDKUI2Color(colorString: "#26000000")
        
        // Set the page limit.
        configuration.outputSettings.pagesScanLimit = 1
        
        // Enable the tutorial screen.
        configuration.screens.camera.introduction.showAutomatically = true
        
        // Disable the acknowledgment screen.
        configuration.screens.camera.acknowledgement.acknowledgementMode = .none
        
        // Disable the review screen.
        configuration.screens.review.enabled = false
        
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
        
        } catch SBSDKError.operationCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } catch {
            // Any other error
            print("Error scanning document: \(error.localizedDescription)")
        }
    }
}
