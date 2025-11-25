//
//  DocumentPreviewModesUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 29.10.25.
//

import Foundation
import ScanbotSDK

class DocumentPreviewModesUI2ViewController: UIViewController {
    
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
        
        // Retrieve the camera screen configuration.
        let cameraScreenConfig = configuration.screens.camera
        
        // Possible preview modes...
        
        // Image with document count badge.
        let imagePreviewMode = SBSDKUI2PagePreviewMode()
        imagePreviewMode.pageCounter.foregroundColor = SBSDKUI2Color(colorString: "#C8193C")
        imagePreviewMode.pageCounter.background.fillColor = SBSDKUI2Color(colorString: "#FFFFFF")

        // Text with document count badge.
        let textWithBadgePreviewMode = SBSDKUI2TextWithBadgeButtonMode()
        textWithBadgePreviewMode.pageCounter.foregroundColor = SBSDKUI2Color(colorString: "#C8193C")
        textWithBadgePreviewMode.text.color = SBSDKUI2Color(colorString: "#FFFFFF")
        textWithBadgePreviewMode.text.visible = true
        
        // Only text.
        let textMode = SBSDKUI2TextButtonMode()
        textMode.style.color = SBSDKUI2Color(colorString: "#FFFFFF")
        
        // No button.
        let noButtonMode = SBSDKUI2NoButtonMode()
        
        // Set the desired mode.
        cameraScreenConfig.bottomBar.previewButton = imagePreviewMode
        
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
