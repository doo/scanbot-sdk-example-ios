//
//  ImageStoringViewController.swift
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 02.12.22.
//

import UIKit
import ScanbotSDK

class ImageStoringViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize a folder URL to persist the images to. 
        let documentsURL = SBSDKStorageLocation.applicationDocumentsFolderURL.appendingPathComponent("Images", isDirectory: true)
        
        // Create a storage location object. This will create the folder on the filesystem if neccessary.
        let documentsLocation = SBSDKStorageLocation(baseURL: documentsURL)
        
        // Initialize an indexed image storage at this location.
        // The indexed image storage is an array-like storage.
        let imageStorage = SBSDKIndexedImageStorage(storageLocation: documentsLocation, 
                                                    fileFormat: .PNG, 
                                                    encrypter: nil)!
        
        if let image = UIImage(named: "testDocument") {
            // Save an image to the storage.
            let isAdded = imageStorage.add(image)
            // Check the result.
            print("Image added successfully: \(isAdded)")
        }
        // Check the number of images in the storage.
        print("Images in storage: \(imageStorage.imageCount)")
        
        
        // Create and attach an encrypter to the storage. This will encrypt the image data, before it is written to disk 
        // and decrypt it after it is read from disk. 
        // Setting the encrypter does not encrypt existing images in the storage, only the images that are added to the 
        // storage after setting the encrypter. 
        imageStorage.encrypter = SBSDKAESEncrypter(password: "xxxxx", mode: .AES256)
        
        // Store an image from a URL. This does not load the image and has a very low memory footprint.
        if let url = Bundle.main.url(forResource: "imageDocument", withExtension: "png") {
            // Copy the image from the URL to the storage.
            let isAdded = imageStorage.addImage(from: url)
            // Check the result.
            print("Image from URL was added successfully : \(isAdded)")
        }
        
        // Make sure that the indices are valid before moving an image from index to another.
        if imageStorage.imageCount > 1 {
            // Move the image at index 1 to index 0.
            let isMoved = imageStorage.moveImage(from: 1, to: 0)
            print("Image was moved successfully: \(isMoved)")
        }
        
        // Make sure that the index is valid.
        if imageStorage.imageCount > 1 {
            // Remove the image at index 1.
            imageStorage.removeImage(at: 1)
        }
        
        // The image storage is persisted on disk. 
        // When the images are no longer needed they should be removed to free the disk space. 
        // Remove all images from the storage.
        imageStorage.removeAll()
    }
}
