//
//  DocumentAcknowledgmentUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 16.07.24.
//

import Foundation
import ScanbotSDK

class DocumentAcknowledgmentUI2ViewController: UIViewController {
    
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

        // Set the acknowledgment mode
        // Modes:
        // - `always`: Runs the quality analyzer on the captured document and always displays the acknowledgment screen.
        // - `badQuality`: Runs the quality analyzer and displays the acknowledgment screen only if the quality is poor.
        // - `none`: Skips the quality check entirely.
        configuration.screens.camera.acknowledgement.acknowledgementMode = .always
        
        // Set the minimum acceptable document quality.
        // Options: excellent, good, reasonable, poor, veryPoor, or noDocument.
        configuration.screens.camera.acknowledgement.minimumQuality = .reasonable
        
        // Set the background color for the acknowledgment screen.
        configuration.screens.camera.acknowledgement.backgroundColor = SBSDKUI2Color(colorString: "#EFEFEF")
        
        // You can also configure the buttons in the bottom bar of the acknowledgment screen.
        // E.g. to force the user to retake, if the captured document is not OK.
        configuration.screens.camera.acknowledgement.bottomBar.acceptWhenNotOkButton.visible = false
        
        // Hide the titles of the buttons.
        configuration.screens.camera.acknowledgement.bottomBar.acceptWhenNotOkButton.title.visible = false
        configuration.screens.camera.acknowledgement.bottomBar.acceptWhenOkButton.title.visible = false
        configuration.screens.camera.acknowledgement.bottomBar.retakeButton.title.visible = false
        
        // Configure the acknowledgment screen's hint message which is shown if the least acceptable quality is not met.
        configuration.screens.camera.acknowledgement.badImageHint.visible = true
        
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
