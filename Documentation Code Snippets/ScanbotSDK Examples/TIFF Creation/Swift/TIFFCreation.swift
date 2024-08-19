//
//  TIFFCreation.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 26.10.21.
//

import Foundation
import ScanbotSDK

func createTIFF() {
    
    // For this example we're using an empty array, but there should be scanned images in it.
    let scannedImages: [UIImage] = []

    // Specify the file URL where the TIFF will be saved to. Nil makes no sense here.
    guard let outputTIFFURL = URL(string: "outputTIFF") else { return }

    // In case you want to encrypt your TIFF file, create encrypter using a password and an encryption mode.
    guard let encrypter = SBSDKAESEncrypter(password: "password_example#42",
                                            mode: .AES256) else { return }
    
    // The `SBSDKTIFFImageWriter` has parameters where you can define various options,
    // e.g. compression algorithm or whether the document should be binarized.
    // For this example we're going to use the default parameters.
    let parameters = SBSDKTIFFImageWriterParameters.defaultParameters
    
    // Create the tiff image writer using created parameters and the encrypter.
    let tiffImageWriter = SBSDKTIFFImageWriter(parameters: parameters, encrypter: encrypter)

    // Asynchronously writes a TIFF file with scanned images into the defined URL.
    // The completion handler passes a file URL where the file was to be saved, or nil if the operation did not succeed.
    tiffImageWriter.writeTIFF(with: scannedImages, toFile: outputTIFFURL, completion: { url in
        
        // Handle the URL.
    })
}
