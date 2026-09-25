//
//  ScanOnImageCroppingUISwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct ScanOnImageCroppingUISwiftUIView: View {
    
    @State private var configuration: SBSDKUI2CroppingStandaloneConfiguration?
    @State private var errorMessage: String?
    
    var body: some View {
        
        if let configuration {
            
            // Create and present the scanner view.
            SBSDKUI2CroppingView(configuration: configuration) { result, error in
                
                // Completion handler to process the result.
                if let result {
                    
                    if let error = result.errorMessage {
                        // There was an error.
                        print(error)
                        
                    } else {
                        // The screen is dismissed without errors.
                    }
                    
                } else {
                    // Indicates that the cancel button was tapped.
                }
                
                if let error {
                    print("Error occurred in cropping screen: \(error.localizedDescription)")
                    errorMessage = error.localizedDescription
                }
                
                self.configuration = nil
            }
            .ignoresSafeArea()
            
        } else if let errorMessage {
            
            // Show error view here.
            Text("Error occurred in cropping screen: \(errorMessage)")
            
        } else {
            
            // Present an image picker.
            ExampleImagePicker { pickedImage in
                prepareCroppingScreen(with: pickedImage)
            }
        }
    }
    
    func prepareCroppingScreen(with pickedImage: UIImage) {
        
        do {
            // Create an instance of a document.
            let document = try SBSDKScannedDocument(documentImageSizeLimit: 0)
            
            // Create an image ref from UIImage.
            let imageRef = SBSDKImageRef.fromUIImage(image: pickedImage)
            
            // Add a page in the document using the picked image.
            let page = try document.addPage(with: imageRef)
            
            // Create the default configuration object.
            let configuration = SBSDKUI2CroppingStandaloneConfiguration(documentUuid: document.uuid, pageUuid: page.uuid)
            
            // Modify the configuration to your needs.
            // E.g. disable the rotation feature.
            configuration.cropping.toolbar.rotateButton.visible = false
            
            // E.g. configure various colors.
            configuration.appearance.topBarBackgroundColor = SBSDKUI2Color(uiColor: UIColor.red)
            configuration.cropping.topBarConfirmButton.foreground.color = SBSDKUI2Color(uiColor: UIColor.white)
            
            // E.g. customize a UI element's text.
            configuration.localization.croppingTopBarCancelButtonTitle = "Cancel"
            
            self.configuration = configuration
        }
        catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    ScanOnImageCroppingUISwiftUIView()
}
