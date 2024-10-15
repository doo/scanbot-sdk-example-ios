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
            
            // Create an instance of a detector
            let detector = SBSDKDocumentDetector()
            
            // Run detection on the image
            let result = detector.detectPhotoPolygon(on: image, visibleImageRect: .zero, smoothingEnabled: false)
            
            // Create an instance of a document
            let document = SBSDKScannedDocument()
            
            // Add page to the document using the image and the detected polygon on the image (if any)
            if let polygon = result?.polygon {
                document.addPage(with: image, polygon: polygon)
            } else {
                document.addPage(with: image)
            }
            
            // Process the document
            let resultViewController = SingleScanResultViewController.make(with: document)
            self.navigationController?.pushViewController(resultViewController, animated: true)
            
            
            // If multiple images are picked
        } else if pickedImages.count > 1 {
            
            // Create an instance of a detector
            let detector = SBSDKDocumentDetector()
            
            // Make an instance of the document
            let document = SBSDKScannedDocument()
            
            // Iterate over multiple picked images
            pickedImages.forEach { image in
                
                // Run detection on the image
                let result = detector.detectPhotoPolygon(on: image, visibleImageRect: .zero, smoothingEnabled: false)
                
                // Add page to the document using the image and the detected polygon on the image (if any)
                if let polygon = result?.polygon {
                    document.addPage(with: image, polygon: polygon)
                } else {
                    document.addPage(with: image)
                }
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
