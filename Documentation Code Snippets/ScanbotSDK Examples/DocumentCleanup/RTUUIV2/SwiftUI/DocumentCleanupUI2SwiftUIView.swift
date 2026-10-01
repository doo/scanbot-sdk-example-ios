//
//  DocumentCleanupUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct DocumentCleanupUI2SwiftUIView: View {
    
    // The configuration of the standalone cleanup screen, created once the image has been imported.
    @State private var configuration: SBSDKUI2DocumentCleanupStandaloneConfiguration?
    
    // The message of the last error, if any.
    @State private var errorMessage: String?
    
    var body: some View {
        
        if let configuration {
            
            // Show the cleanup screen, passing the configuration and handling the result.
            if let cleanupView = try? SBSDKUI2DocumentCleanupView(configuration: configuration,
                                                                  completion: { result, error in
                
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
                
                self.configuration = nil
            }) {
                cleanupView
                    .ignoresSafeArea()
            } else {
                Text("Failed to initialize the document cleanup screen.")
            }
            
        } else if let errorMessage {
            
            // Show error view here.
            Text("Error occurred in cleanup screen: \(errorMessage)")
            
        } else {
            
            // Present an image picker.
            ExampleImagePicker { pickedImage in
                prepareCleanupScreen(with: pickedImage)
            }
        }
    }
    
    func prepareCleanupScreen(with pickedImage: UIImage) {
        
        do {
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
            
            self.configuration = configuration
        }
        catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    DocumentCleanupUI2SwiftUIView()
}
