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
    
    // Create the TIFF generator using created parameters.
    let generator = SBSDKTIFFGenerator(parameters: parameters)
    
    // Synchronously convert the scanned document to a multipage-TIFF file and saves it to the specified URL.
    // If output URL is `nil`the default TIFF location of the scanned document will be used.
    generator.generate(from: scannedDocument)
}

func createTIFF(from images: [UIImage]) {
    
    // Specify the file URL where the TIFF will be saved to.
    guard let outputTIFFURL = URL(string: "outputTIFF") else { return }

    // In case you want to encrypt your TIFF file, create encrypter using a password and an encryption mode.
    let encrypter = SBSDKAESEncrypter(password: "password_example#42", mode: .AES256)
    
    // The `SBSDKTIFFGenerator` has parameters where you can define various options,
    // e.g. compression algorithm or whether the document should be binarized.
    let parameters = SBSDKTIFFGeneratorParameters()
    
    // Create the TIFF generator using created parameters and the encrypter.
    let tiffImageGenerator = SBSDKTIFFGenerator(parameters: parameters, encrypter: encrypter)

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
