//
//  TIFFCreation.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 26.10.21.
//

import Foundation
import ScanbotSDK

func createTIFF(from scannedDocument: SBSDKScannedDocument) {
    
    // The `SBSDKTIFFGenerator` has parameters where you can define various options,
    // e.g. compression algorithm or whether the document should be binarized.
    let parameters = SBSDKTIFFGeneratorParameters()
    
    // Create the TIFF generator using created parameters, do not encrypt the generated TIFF files.
    let generator = SBSDKTIFFGenerator(parameters: parameters, useEncryptionIfAvailable: false)
    
    // Synchronously convert the scanned document to a multipage-TIFF file and saves it to the specified URL.
    // If output URL is `nil`the default TIFF location of the scanned document will be used.
    generator.generate(from: scannedDocument)
}

func createTIFF(from images: [UIImage]) {
    
    // Specify the file URL where the TIFF will be saved to.
    guard let outputTIFFURL = URL(string: "outputTIFF") else { return }

    // In case you want to encrypt your TIFF file, create a crypting provider, using a password and an encryption mode.
    let cryptingProvider = SBSDKCryptingProvider(block: {
        
        // Create and return the AES encrypter with a password and an encryption mode.
        // You can also use other encrypters, like `SBSDKAESGCM`.
        // Make sure, you always create a new instance of the encrypter in this block.
        return SBSDKAESEncrypter(password: "password_example#42", mode: .AES256)
    })
    
    // Set the created crypting provider as the default one for Scanbot SDK.
    // Important: If you set a default crypting provider, all other Scanbot SDK components will also use this encrypter, including all stored images.
    Scanbot.setDefaultCryptingProvider(cryptingProvider)

    // The `SBSDKTIFFGenerator` has parameters where you can define various options,
    // e.g. compression algorithm or whether the document should be binarized.
    let parameters = SBSDKTIFFGeneratorParameters()
    
    // Create the TIFF generator using created parameters, enable encryption of the generated TIFF files.
    let tiffImageGenerator = SBSDKTIFFGenerator(parameters: parameters, useEncryptionIfAvailable: true)

    // Create ImageRefs from UIImages.
    let imageRefs: [SBSDKImageRef] = images.map { uiImage in
        SBSDKImageRef.fromUIImage(image: uiImage)
    }
    
    // Asynchronously generate a multipage-TIFF file from the given images and save it to the specified URL.
    // The completion handler passes a file URL where the file was to be saved, or nil if the operation did not succeed.
    tiffImageGenerator.generate(from: imageRefs, to: outputTIFFURL, completion: { url in
        
        // Handle the URL.
    })
}
