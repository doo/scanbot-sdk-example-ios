//
//  PickFromGalleryViewController.swift
//  DocumentScannerRTUUIExample
//
//  Created by Rana Sohaib on 24.08.23.
//

import PhotosUI
import ScanbotSDK

final class PickFromGalleryViewController: UIViewController {
    
    @IBOutlet private var uploadImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadImageButton.layer.cornerRadius = 8
    }
    
    private func showResult(for pickedImages: [UIImage]) {
        
        // If only one image is picked
        if pickedImages.count == 1,
           let image = pickedImages.first {
            
            // Create a document page by passing the image
            // You can pass the polygon of the area where the document is located within the pages image
            // You can also pass an array of filters you want to apply on the page
            let page = SBSDKDocumentPage(image: image, polygon: nil, parametricFilters: [])
            
            // Detect a document on the page
            let result = page.detectDocument(applyPolygonIfOkay: true)
            
            // Set the detected polygon (if any) on the document page
            page.polygon = result?.polygon
            
            // Create an instance of a document
            let document = SBSDKDocument()
            
            // Insert the page in the document
            document.insert(page, at: 0)
            
            // Process the document
            let resultViewController = SingleScanResultViewController.make(with: document)
            self.navigationController?.pushViewController(resultViewController, animated: true)
            
            
            // If multiple images are picked
        } else if pickedImages.count > 1 {
            
            // Make an instance of the document
            let document = SBSDKDocument()
            
            // Iterate over multiple picked images
            pickedImages.forEach { image in
                
                // Create a document page by passing the image
                // You can pass the polygon of the area where the document is located within the pages image
                // You can also pass an array of filters you want to apply on the page
                let page = SBSDKDocumentPage(image: image, polygon: nil, parametricFilters: [])
                
                // Detect a document on the page
                let result = page.detectDocument(applyPolygonIfOkay: true)
                
                // Set the detected polygon (if any) on the document page
                page.polygon = result?.polygon
                
                // Insert the page in the document
                document.insert(page, at: document.pages.count)
            }
            
            // Process the document
            let resultViewController = MultiScanResultViewController.make(with: document)
            self.navigationController?.pushViewController(resultViewController, animated: true)
        }
    }
}

extension PickFromGalleryViewController {
    
    @IBAction private func uploadImageButtonTapped(_ sender: UIButton) {
        
        if #available(iOS 14.0, *) {
            
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 0
            configuration.filter = .images
            
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            
            self.present(picker, animated: true)
            
        } else {
            
            let picker = UIImagePickerController()
            picker.delegate = self
            self.present(picker, animated: true)
        }
    }
}

// Image Picker for iOS 14 and above
@available(iOS 14.0, *)
extension PickFromGalleryViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        var pickedImages = [UIImage]()
        
        let dispatchGroup = DispatchGroup()
        
        results.forEach { result in
            
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                
                dispatchGroup.enter()
                
                result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    
                    if let image = image as? UIImage {
                        pickedImages.append(image)
                    }
                    
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.showResult(for: pickedImages)
        }
    }
}

// Image picker for iOS 13
extension PickFromGalleryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        self.showResult(for: [image])
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension PickFromGalleryViewController {
    static func make() -> PickFromGalleryViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "PickFromGalleryViewController")
        as! PickFromGalleryViewController
        return viewController
    }
}
