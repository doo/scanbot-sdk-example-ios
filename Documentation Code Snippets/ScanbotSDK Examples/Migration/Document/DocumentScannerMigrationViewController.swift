//
//  DocumentScannerMigrationViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 27.11.25.
//

import UIKit
import ScanbotSDK

// With RTU UI v.2.0 we don't need to implement a delegate in our ViewController anymore
class DocumentScannerMigrationViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // We will process a scanned document here:
    func processDocument(document: SBSDKScannedDocument) {
        // This is how we can access the document preview image from the SBSDKScannedDocument
        imageView.image = try? document.pages.first?.documentImagePreview?.toUIImage()
    }
    
    @IBAction func openScannerTapped(_ sender: Any) {
        Task {
            await openDocumentScannerRtuV2()
        }
    }
    
    func openDocumentScannerRtuV2() async {

        // See the next section for the configuration migration details.
        // ...
        // Create the default configuration object.
        let configuration = SBSDKUI2DocumentScanningFlow()
        
        // Present the view controller modally.
        do {
            let scannedDocument = try await SBSDKUI2DocumentScannerController.present(on: self,
                                                                                      configuration: configuration)
            self.processDocument(document: scannedDocument)

        } catch SBSDKError.operationCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } catch {
            // Any other error
            print("Error scanning document: \(error.localizedDescription)")
        }
        // ..
    }
    
    func configExampleDocumentScannerRtuV2() async {
        
        let configuration = SBSDKUI2DocumentScanningFlow()

        let cameraScreenConfiguration = configuration.screens.camera

        // Equivalent to behaviorConfiguration.ignoreBadAspectRatio = true
        cameraScreenConfiguration.scannerParameters.ignoreOrientationMismatch = true

        // Equivalent to behaviorConfiguration.autoSnappingSensitivity = 0.75
        cameraScreenConfiguration.cameraConfiguration.autoSnappingSensitivity = 0.75

        // Ready-to-Use UI v2 contains an acknowledgment screen to
        // verify the captured document with the built-in Document Quality Analyzer.
        // You can still disable this step:
        cameraScreenConfiguration.acknowledgement.acknowledgementMode = SBSDKUI2AcknowledgementMode.none

        // When you disable the acknowledgment screen, you can enable the capture feedback,
        // there are different options available, for example you can display a checkmark animation:
        cameraScreenConfiguration.captureFeedback.snapFeedbackMode = SBSDKUI2PageSnapFeedbackMode.pageSnapCheckMarkAnimation()

        // You may hide the import button in the camera screen, if you don't need it:
        cameraScreenConfiguration.bottomBar.importButton.visible = false

        // Equivalent to uiConfiguration.bottomBarBackgroundColor = UIColor.blue, but not recommended:
        configuration.appearance.bottomBarBackgroundColor = SBSDKUI2Color(uiColor: UIColor.blue)

        // However, now all the colors can be conveniently set using the Palette object:
        let palette = configuration.palette
        palette.sbColorPrimary = SBSDKUI2Color(uiColor: UIColor.blue)
        palette.sbColorOnPrimary = SBSDKUI2Color(uiColor: UIColor.white)
        // ..

        // Now all the text resources are in the localization object
        let localization = configuration.localization
        localization.cameraUserGuidanceReadyToCapture = "Don't move. Capturing document..."

        // Ready-to-Use UI v2 contains a review screen, you can disable it:
        configuration.screens.review.enabled = false

        // Multi Page button is always hidden in RTU v2
        // Therefore uiConfiguration.isMultiPageButtonHidden = true is not available

        // Equivalent to behaviorConfiguration.isMultiPageEnabled = false
        configuration.outputSettings.pagesScanLimit = 1

        // Present the view controller modally.
        do {
            let scannedDocument = try await SBSDKUI2DocumentScannerController.present(on: self,
                                                                                      configuration: configuration)
            self.processDocument(document: scannedDocument)

        } catch SBSDKError.operationCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } catch {
            // Any other error
            print("Error scanning document: \(error.localizedDescription)")
        }
    }
    
    func openFinderDocumentScannerRtuV2() async {
        
        let configuration = SBSDKUI2DocumentScanningFlow()

        let palette = configuration.palette
        palette.sbColorPrimary = SBSDKUI2Color(uiColor: UIColor.blue)
        palette.sbColorOnPrimary = SBSDKUI2Color(uiColor: UIColor.white)
        // ..

        let cameraScreenConfiguration = configuration.screens.camera

        let viewFinder = cameraScreenConfiguration.viewFinder
        viewFinder.visible = true
        viewFinder.aspectRatio = SBSDKAspectRatio(width: 3, height: 4)

        let bottomBar = cameraScreenConfiguration.bottomBar
        bottomBar.previewButton = SBSDKUI2PreviewButton.noButtonMode()
        bottomBar.autoSnappingModeButton.visible = false
        bottomBar.importButton.visible = false

        cameraScreenConfiguration.acknowledgement.acknowledgementMode = SBSDKUI2AcknowledgementMode.none
        cameraScreenConfiguration.captureFeedback.snapFeedbackMode = SBSDKUI2PageSnapFeedbackMode.pageSnapCheckMarkAnimation()

        configuration.screens.review.enabled = false
        configuration.outputSettings.pagesScanLimit = 1

        // Present the view controller modally.
        do {
            let scannedDocument = try await SBSDKUI2DocumentScannerController.present(on: self,
                                                                                      configuration: configuration)
            self.processDocument(document: scannedDocument)
            
        } catch SBSDKError.operationCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } catch {
            // Any other error
            print("Error scanning document: \(error.localizedDescription)")
        }
    }
    
    func createFromDocument(_ document: SBSDKDocument) throws -> SBSDKScannedDocument? {

        // Create the scanned document using convenience initializer `init?(document:documentImageSizeLimit:)`.
        // `SBSDKDocument` doesn't support `documentImageSizeLimit`, but you can add it to unify size of the documents.
        let scannedDocument = try SBSDKScannedDocument(document: document, documentImageSizeLimit: 2048)
        
        // Return newly created scanned document.
        return scannedDocument
    }
}
