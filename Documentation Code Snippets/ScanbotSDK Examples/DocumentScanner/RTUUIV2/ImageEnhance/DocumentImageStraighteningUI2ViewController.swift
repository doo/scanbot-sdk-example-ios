//
//  DocumentImageStraighteningUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 22.03.26.
//

import Foundation
import ScanbotSDK

class DocumentImageStraighteningUI2ViewController: UIViewController {
    
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
        
        // Create the parameters.
        let parameters = SBSDKDocumentStraighteningParameters()
        
        
        // Configure the properties.
        // e.g
        parameters.straighteningMode = .straighten
        parameters.aspectRatios = [SBSDKAspectRatio(width: 1, height: 1),
                                   SBSDKAspectRatio(width: 16, height: 9),
                                   SBSDKAspectRatio(width: 3, height: 4)]
        
        // Set the straightening parameters newly created.
        configuration.outputSettings.straighteningParameters = parameters
        
        // Pass the DOCUMENT_UUID here to resume an old session, or pass nil to start a new session or to resume a draft session.
        configuration.documentUuid = nil
        
        // Controls whether to resume an existing draft session or start a new one when DOCUMENT_UUID is nil.
        configuration.cleanScanningSession = true
        
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
                
                // Document image is straightened.
                let documentImage = scannedPage.documentImage
                let documentImageURI = scannedPage.documentImageURI
                
                // Document image preview is straightened.
                let documentImagePreview = scannedPage.documentImagePreview
                let documentImagePreviewURI = scannedPage.documentImagePreviewURI
                
            }
            
        } catch SBSDKError.operationCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } catch {
            // Any other error
            print("Error scanning document: \(error.localizedDescription)")
        }
    }
}
