//
//  ImageRefExample.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 03.11.25.
//

import UIKit
import ScanbotSDK
import CoreMedia

class ImageRefExample {
    
    func imageRef(from image: UIImage) {
        
        // Create ImageRef from UIImage.
        let imageRef = SBSDKImageRef.fromUIImage(image: image)
        
        // To create ImageRef from UIImage with options.
        // e.g to create ImageRef from a cropped area of the UIImage...
        // Create Raw Image Load options.
        let options = SBSDKRawImageLoadOptions(
            cropRect: CGRect(x: 0, y: 0, width: 200, height: 200),
            origin: .topLeft,
            orientation: .none
        )
        // Create ImageRef using the image and options.
        let croppedImageRef = SBSDKImageRef.fromUIImage(image: image, options: options)
    }
    
    func imageRef(from sampleBuffer: CMSampleBuffer) {
        
        // Create ImageRef from sample buffer.
        let imageRef = SBSDKImageRef.fromSampleBuffer(sampleBuffer: sampleBuffer)
        
        // To create ImageRef from sample buffer with options.
        // e.g to create ImageRef from a cropped area...
        // Create Raw Image Load options.
        let options = SBSDKRawImageLoadOptions(
            cropRect: CGRect(x: 0, y: 0, width: 200, height: 200),
            origin: .topLeft,
            orientation: .none
        )
        // Create ImageRef using the sample buffer and options.
        let croppedImageRef = SBSDKImageRef.fromSampleBuffer(sampleBuffer: sampleBuffer, options: options)
    }
    
    func imageRef(from encodedBuffer: Data) {
        
        // Create ImageRef from encoded buffer.
        let imageRef = SBSDKImageRef.fromEncodedBuffer(encodedBuffer: encodedBuffer)
        
        // To create ImageRef from encoded buffer with options.
        // e.g to create ImageRef from a cropped area...
        // Create Buffer Image Load options.
        let options = SBSDKBufferImageLoadOptions(
            cropRect: CGRect(x: 0, y: 0, width: 200, height: 200),
            colorConversion: .gray,
            loadMode: .lazy
        )
        // Create ImageRef using the encoded buffer and options.
        let croppedImageRef = SBSDKImageRef.fromEncodedBuffer(encodedBuffer: encodedBuffer, options: options)
    }
    
    func imageRef(from fileUrl: URL) {
        
        do {
            // Create ImageRef from an image at a specified URL.
            let imageRef = try SBSDKImageRef.fromURL(url: fileUrl)
            
            // To create ImageRef from URL with options.
            // e.g to create ImageRef from a cropped area...
            // Create Path Image Load options.
            let options = SBSDKPathImageLoadOptions(
                cropRect: CGRect(x: 0, y: 0, width: 200, height: 200),
                colorConversion: .gray,
                loadMode: .lazyWithCopy,
                encryptionMode: .required,
                decrypter: Scanbot.defaultCryptingProvider
            )
            // Create ImageRef using the URL and options.
            let croppedImageRef = try SBSDKImageRef.fromURL(url: fileUrl, options: options)
        }
        catch {
            print("Error creating ImageRef from fileURL: \(error.localizedDescription)")
        }
    }
    
    func imageRef(from filePath: String) {
        
        // Create ImageRef from an image at a specified path.
        let imageRef = SBSDKImageRef.fromPath(path: filePath)
        
        // To create ImageRef from filePath with options.
        // e.g to create ImageRef from a cropped area...
        // Create Path Image Load options.
        let options = SBSDKPathImageLoadOptions(
            cropRect: CGRect(x: 0, y: 0, width: 200, height: 200),
            colorConversion: .gray,
            loadMode: .lazyWithCopy,
            encryptionMode: .required,
            decrypter: Scanbot.defaultCryptingProvider
        )
        // Create ImageRef using the filePath and options.
        let croppedImageRef = SBSDKImageRef.fromPath(path: filePath, options: options)
    }
    
    func saveImageRef(_ imageRef: SBSDKImageRef, to url: URL) {
        do {
            // Configure the Image Options.
            let options = SBSDKSaveImageOptions(
                quality: 100,
                encryptionMode: .required,
                encrypter: Scanbot.defaultCryptingProvider
            )
            // Save the ImageRef.
            try imageRef.saveToURL(url: url, options: options)
        }
        catch {
            print("Error saving Image Ref: \(error.localizedDescription)")
        }
    }
    
    func saveImageRef(_ imageRef: SBSDKImageRef, to path: String) {
        do {
            // Configure the Image Options.
            let options = SBSDKSaveImageOptions(
                quality: 100,
                encryptionMode: .required,
                encrypter: Scanbot.defaultCryptingProvider
            )
            // Save the ImageRef.
            try imageRef.saveImage(path: path, options: options)
        }
        catch {
            print("Error saving Image Ref: \(error.localizedDescription)")
        }
    }
    
    func image(from imageRef: SBSDKImageRef) {
        
        do {
            // Create UIImage from ImageRef.
            let uiImage = try imageRef.toUIImage()
        }
        catch {
            print("Error converting ImageRef to UIImage: \(error.localizedDescription)")
        }
    }
    
    func getImageRefMetaData(imageRef: SBSDKImageRef) {
        
        do {
            
            // Retrieve ImageRef's metadata.
            let metaData = try imageRef.info()
            
            print("Width: \(metaData.width)")
            print("Height: \(metaData.height)")
            print("Max Byte Size: \(metaData.maxByteSize)")
        }
        catch {
            print("Error getting ImageRef metadata: \(error.localizedDescription)")
        }
    }
}
