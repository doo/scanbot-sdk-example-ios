//
//  ScanOnImageCroppingUIViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 28.08.24.
//

import Foundation
import ScanbotSDK

class ScanOnImageCroppingUIViewController: UIViewController,
                                           UIImagePickerControllerDelegate,
                                           UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Present an image picker.
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let pickedImage = info[.originalImage] as? UIImage else { return }
        
        picker.dismiss(animated: true) {
            do {
                try self.presentCroppingScreen(with: pickedImage)
            }
            catch {
                print("Error occurred in cropping screen: \(error.localizedDescription)")
            }
        }
    }
    
    func presentCroppingScreen(with pickedImage: UIImage) throws {
        
        // Create an instance of document.
        let document = try SBSDKScannedDocument(documentImageSizeLimit: 0)
        
        // Create an image ref from UIImage.
        let imageRef = SBSDKImageRef.fromUIImage(image: pickedImage)
        
        // Add a page in document using the picked image.
        let page = try document.addPage(with: imageRef)
        
        // Create the default configuration object.
        let configuration = SBSDKUI2CroppingConfiguration(documentUuid: document.uuid, pageUuid: page.uuid)
        
        // Modify the configuration to your needs.
        // E.g. disable the rotation feature.
        configuration.cropping.bottomBar.rotateButton.visible = false
        
        // E.g. configure various colors.
        configuration.appearance.topBarBackgroundColor = SBSDKUI2Color(uiColor: UIColor.red)
        configuration.cropping.topBarConfirmButton.foreground.color = SBSDKUI2Color(uiColor: UIColor.white)
        
        // E.g. customize a UI element's text.
        configuration.localization.croppingTopBarCancelButtonTitle = "Cancel"
        
        // Present the view controller modally.
        try SBSDKUI2CroppingViewController.present(on: self,
                                                   configuration: configuration) { controller, result, error in
            
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
        }
    }
}
