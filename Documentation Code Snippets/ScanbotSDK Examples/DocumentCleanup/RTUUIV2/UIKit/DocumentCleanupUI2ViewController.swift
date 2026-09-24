//
//  DocumentCleanupUI2ViewController.swift
//  ScanbotSDK Examples
//

import Foundation
import ScanbotSDK

class DocumentCleanupUI2ViewController: UIViewController,
                                        UIImagePickerControllerDelegate,
                                        UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Present an image picker. In a real application this is usually triggered by a button.
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let pickedImage = info[.originalImage] as? UIImage else { return }
        
        picker.dismiss(animated: true) {
            do {
                try self.presentCleanupScreen(with: pickedImage)
            }
            catch {
                print("Error occurred in cleanup screen: \(error.localizedDescription)")
            }
        }
    }
    
    func presentCleanupScreen(with pickedImage: UIImage) throws {
        
        // Create an instance of a document.
        let document = try SBSDKScannedDocument(documentImageSizeLimit: 0)
        
        // Create an image ref from UIImage.
        let imageRef = SBSDKImageRef.fromUIImage(image: pickedImage)
        
        // Add a page to the document using the picked image.
        let page = try document.addPage(with: imageRef)
        
        // Create the default configuration object for the standalone cleanup screen.
        let configuration = SBSDKUI2DocumentCleanupStandaloneConfiguration(documentUuid: document.uuid,
                                                                          pageUuid: page.uuid)
        
        // Modify the configuration to your needs.
        // E.g. disable the stroke size slider.
        configuration.cleanup.toolbar.strokeSizeSlider.visible = false
        
        // E.g. configure the underlying cleanup engine.
        configuration.cleanup.engineConfiguration.keepText = true
        configuration.cleanup.engineConfiguration.maxUndoRedoStackSize = 10
        
        // E.g. configure various colors.
        configuration.appearance.topBarBackgroundColor = SBSDKUI2Color(uiColor: UIColor.red)
        configuration.cleanup.topBarConfirmButton.foreground.color = SBSDKUI2Color(uiColor: UIColor.white)
        
        // E.g. customize a UI element's text.
        configuration.localization.documentCleanupTopBarCancelButtonTitle = "Cancel"
        
        // Present the view controller modally.
        try SBSDKUI2DocumentCleanupViewController.present(on: self,
                                                          configuration: configuration) { controller, result, error in
            
            // Completion handler to process the result.
            if let result {
                
                if let errorMessage = result.errorMessage {
                    // There was an error.
                    print(errorMessage)
                    
                } else {
                    // The screen is dismissed without errors.
                    do {
                        // Retrieve the cleaned up document and page.
                        let cleanedDocument = try SBSDKScannedDocument.loadDocument(documentUuid: result.documentUuid)
                        let cleanedPage = try cleanedDocument.page(with: result.pageUuid)
                        
                        // Proceed with the page as needed.
                        let cleanedImage = cleanedPage.documentImage
                        
                    } catch {
                        print("Error loading the cleaned up document: \(error.localizedDescription)")
                    }
                }
                
            } else {
                // Indicates that the cancel button was tapped or the screen was closed for another reason.
            }
            
            if let error {
                // Any other error, e.g. an invalid license.
                print("Error cleaning up the document: \(error.localizedDescription)")
            }
        }
    }
}
