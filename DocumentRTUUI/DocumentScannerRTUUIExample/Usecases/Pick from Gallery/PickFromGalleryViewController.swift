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
    
    private func showResult(for pickedImages: [UIImage]) throws {
        
        // If only one image is picked
        if pickedImages.count == 1,
           let image = pickedImages.first {
            
            // Create an instance of the scanner
            let scanner = try SBSDKDocumentScanner()
            
            // Create an SBSDKImageRef from the image.
            let imageRef = SBSDKImageRef.fromUIImage(image: image)
            
            // Scan from the imageRef
            let result = try scanner.run(image: imageRef)
            
            // Create an instance of a document
            let document = try SBSDKScannedDocument(documentImageSizeLimit: 0)
            
            // Add page to the document using the image and the detected polygon on the image (if any)
            if let polygon = result.polygon {
                try document.addPage(with: imageRef, polygon: polygon)
            } else {
                try document.addPage(with: imageRef)
            }
            
            // Process the document
            let resultViewController = SingleScanResultViewController.make(with: document)
            self.navigationController?.pushViewController(resultViewController, animated: true)
            
            
            // If multiple images are picked
        } else if pickedImages.count > 1 {
            
            // Create an instance of the scanner
            let scanner = try SBSDKDocumentScanner()
            
            // Make an instance of the document
            let document = try SBSDKScannedDocument(documentImageSizeLimit: 0)
            
            // Iterate over multiple picked images
            try pickedImages.forEach { image in
                
                // Create an SBSDKImageRef from the image.
                let imageRef = SBSDKImageRef.fromUIImage(image: image)
                
                // Scan from the imageRef
                let result = try scanner.run(image: imageRef)
                
                // Add page to the document using the image and the detected polygon on the image (if any)
                if let polygon = result.polygon {
                    try document.addPage(with: imageRef, polygon: polygon)
                } else {
                    try document.addPage(with: imageRef)
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
        
        // Run after dismissal completes; otherwise alerts can't be presented
        // because the `presentedViewController` is still the PHPickerViewController.
        picker.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            
            Task {
                do {
                    let pickedImages = try await self.fetchMultipleImages(results: results)
                    
                    try await MainActor.run  {
                        try self.showResult(for: pickedImages)
                    }
                    
                } catch {
                    self.sbsdk_showError(error)
                }
            }
        }
    }
    
    private func fetchMultipleImages(results: [PHPickerResult]) async throws -> [UIImage] {
        let imageItems = results
            .map { $0.itemProvider }
            .filter { $0.canLoadObject(ofClass: UIImage.self) }
        
        return try await withThrowingTaskGroup(of: UIImage?.self) { [weak self] group in
            guard let self else { return [] }
            for imageItem in imageItems {
                group.addTask {
                    if let image = try await self.loadImage(from: imageItem) {
                        return image
                    } else {
                        return nil
                    }
                }
            }
            
            var loadedImages: [UIImage] = []
            for try await imageResult in group {
                if let imageResult = imageResult {
                    loadedImages.append(imageResult)
                }
            }
            
            return loadedImages
        }
    }
    
    @Sendable
    private func loadImage(from provider: NSItemProvider) async throws -> UIImage? {
        return try await withCheckedThrowingContinuation { continuation in
            provider.loadObject(ofClass: UIImage.self) { (image, error) in
                
                if let image = image as? UIImage {
                    continuation.resume(returning: image)
                } else if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: SBSDKError.unknownError("Could not get the image"))
                }
            }
        }
    }
}
// Image picker for iOS 13
extension PickFromGalleryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Just to ensure that it dosn't happen too to iOS 13 devices.
        picker.dismiss(animated: true) {
            guard let image = info[.originalImage] as? UIImage else {
                return
            }
            do {
                try self.showResult(for: [image])
            } catch {
                self.sbsdk_showError(error)
            }
        }
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
