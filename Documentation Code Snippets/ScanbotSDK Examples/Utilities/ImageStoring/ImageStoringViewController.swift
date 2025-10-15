//
//  ImageStoringViewController.swift
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 02.12.22.
//

import UIKit
import ScanbotSDK

class ImageStoringViewController: UIViewController {
    
    func createIndexedImageStorage() {
        
        // Initialize a folder URL within the application's documents folder to persist the images to.
        let documentsURL = SBSDKStorageLocation.applicationDocumentsFolderURL.appendingPathComponent("Images", isDirectory: true)
        
        // Create a storage location object. This will create the folder on the filesystem if neccessary.
        let documentsLocation = SBSDKStorageLocation(baseURL: documentsURL)
        
        // Create a crypting provider for the storage. This will encrypt the image data, before it is written to disk
        // and decrypt it after it is read from disk.
        // Setting the crypting provider does not encrypt existing images in the storage, only the images that are added to the
        // storage after setting the crypting provider.
        // Passing a crypting provider to the indexed image storage will ignore the global Scanbot SDK crypting provider.
        let cryptingProvider = SBSDKCryptingProvider(block: {
            // Create and return an AES encrypter instance.
            return SBSDKAESEncrypter(password: "xxxxx", mode: .AES256)
        })
        
        // Initialize an indexed image storage at this location.
        // The indexed image storage is an array-like, disk-backed image storage.
        guard let imageStorage = SBSDKIndexedImageStorage(storageLocation: documentsLocation,
                                                          fileFormat: .PNG,
                                                          encryptionMode: .required,
                                                          cryptingProvider: cryptingProvider) else {
            return
        }
    }
    
    func basicOperationsOnIndexedImageStorage() {
        
        // Create a temporary indexed image storage. 
        // A temporary storage will delete its stored images upon deallocation.
        guard let imageStorage = SBSDKIndexedImageStorage.temporary else { return }
        
        if let image = UIImage(named: "testDocument") {
            
            // Create an image ref from UIImage.
            let imageRef = SBSDKImageRef.fromUIImage(image: image)
            
            // Save an image to the storage.
            let isAdded = imageStorage.add(imageRef)
            // Check the result.
            print("Image added successfully: \(isAdded)")
        }
        // Check the number of images in the storage.
        print("Images in storage: \(imageStorage.imageCount)")
        
        // Store an image from a URL. This does not decompress the image data and has a lower memory footprint.
        if let url = Bundle.main.url(forResource: "imageDocument", withExtension: "png") {
            // Add the image from the URL to the storage.
            let isAdded = imageStorage.addImage(from: url)
            // Check the result.
            print("Image from URL was added successfully : \(isAdded)")
        }
        
        // Make sure that the indices are valid before moving an image from one index to another.
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
        
        // When the images are no longer needed they should be removed to free the disk space. 
        // Remove all images explicitly from the storage. This is not necessary for temporary storages.
        imageStorage.removeAll()
    }
    
    func basicOperationsOnKeyedImageStorage() {
        
        // Create a keyed image storage at the default location. 
        // A keyed image storage is a key-value-based, disk-backed storage for images. Think of it as a dictionary.
        let imageStorage = SBSDKKeyedImageStorage()!
        
        // Create an image.
        guard let image = UIImage(named: "testImage") else { return }

        // Create a key string.
        let key = "testKey"

        // Create an image ref from UIImage.
        let imageRef = SBSDKImageRef.fromUIImage(image: image)
        
        // Put the image into the storage using the key.
        imageStorage.set(image: imageRef, for: key)

        // Get the image belonging to the key.
        let storedImage = imageStorage.image(for: key)

        // Remove the image belonging to the key.
        imageStorage.removeImage(for: key)

        // Create a prefix.
        let prefix = "test"

        // Remove the images from the image storage for keys that match the prefix.
        imageStorage.removeImages(matchingPrefix: prefix)
    }
}
