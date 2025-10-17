//
//  BarcodeImageResultHandlingViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 15.07.25.
//

import Foundation
import ScanbotSDK

class BarcodeImageResultHandlingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // The barcode formats to be scanned.
        let formatsToDetect = SBSDKBarcodeFormats.common
        
        // Create an instance of `SBSDKBarcodeFormatCommonConfiguration`.
        let formatConfiguration = SBSDKBarcodeFormatCommonConfiguration(formats: formatsToDetect)
        
        // Create an instance of `SBSDKBarcodeScannerConfiguration`.
        let configuration = SBSDKBarcodeScannerConfiguration(barcodeFormatConfigurations: [formatConfiguration])
        
        // Configure the scanner to return barcode image.
        configuration.returnBarcodeImage = true
        
        do {
            // Create the scanner instance.
            let scanner = try SBSDKBarcodeScanner()
            
            let image = UIImage(named: "test_image")!
            
            // Create an image ref from UIImage.
            let imageRef = SBSDKImageRef.fromUIImage(image: image)
            
            // Run the scanner passing the image.
            let result = try scanner.run(image: imageRef)
            
            // Handle the result.
            result.barcodes.forEach({ barcode in
                handle(barcode: barcode)
            })
        }
        catch {
            print("Error running barcode scanner: \(error.localizedDescription)")
        }
    }
    
    // Handle the resulting barcode item's image.
    func handle(barcode: SBSDKBarcodeItem) {
        
        // Make sure to set `returnBarcodeImage` to true in `SBSDKBarcodeScannerConfiguration` when setting up the scanner.
        
        // Retrieve the barcode image.
        let image = barcode.sourceImage
        
        // Since the image is of type `SBSDKImageRef`, it provides some useful operations.
        // e.g
        
        do {
            // Convert to UIImage.
            let uiImage = try image?.toUIImage()
            
            // Information about the stored image.
            let info = try image?.info()
            
            // Save the image.
            try image?.saveImage(path: "<path_to_save_at>",
                                 options: SBSDKSaveImageOptions(quality: 70, encryptionMode: .disabled))
        }
        catch {
            print("Error handling barcode image: \(error.localizedDescription)")
        }
    }
}
