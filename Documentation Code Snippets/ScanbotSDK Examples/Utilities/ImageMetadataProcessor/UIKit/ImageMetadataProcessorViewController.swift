//
//  ImageMetadataProcessorViewController.swift
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 01.12.22.
//

import UIKit
import ScanbotSDK

class ImageMetadataProcessorViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the desired image.
        if let image = UIImage(named: "documentImage") {
            
            // Convert the image to data.
            guard let imageData = image.jpegData(compressionQuality: 0) else { return }
            
            // Extract the image's metadata.
            if let oldExtractedMetadata = SBSDKImageMetadataProcessor.extractMetadata(from: imageData) {
                
                self.printExtractedMetadata(metadata: oldExtractedMetadata, withTitle: "OLD metadata")
                
                // Create new metadata or modify the extracted metadata.
                if let injectedMetadata = SBSDKImageMetadata(with: oldExtractedMetadata.metadataDictionary) {
                    injectedMetadata.title = "Scanbot SDK"
                    injectedMetadata.originalDate = Date()
                    
                    // Inject the new metadata into the image data.
                    let newImageData = SBSDKImageMetadataProcessor.imageDataByInjecting(metadata: injectedMetadata, into: imageData)
                    
                    // Re-extract the new metadata again.
                    if let newImageData,
                       let newExtractedMetadata = SBSDKImageMetadataProcessor.extractMetadata(from: newImageData) {
                        self.printExtractedMetadata(metadata: newExtractedMetadata, withTitle: "NEW metadata")
                    }
                }
            }
        }
    }
    
    // Print some of the metadata fields.
    func printExtractedMetadata(metadata: SBSDKImageMetadata?, withTitle title: String) {
        if let metadata {
            print("Begin of \(title) *************")
            print("altitude: \(String(describing: metadata.altitude))")
            print("latitude: \(String(describing: metadata.latitude))")
            print("longitude: \(String(describing: metadata.longitude))")
            print("aperture: \(String(describing: metadata.aperture))")
            print("digitalizationDate: \(String(describing: metadata.digitalizationDate?.description))")
            print("exposureTime: \(String(describing: metadata.exposureTime))")
            print("focalLength: \(String(describing: metadata.focalLength))")
            print("focalLength35mm: \(String(describing: metadata.focalLength35mm))")
            print("imageHeight: \(String(describing: metadata.imageHeight))")
            print("imageWidth: \(String(describing: metadata.imageWidth))")
            print("isoValue: \(String(describing: metadata.ISOValue))")
            print("lensMaker: \(String(describing: metadata.lensMaker))")
            print("lensModel: \(String(describing: metadata.lensModel))")
            print("orientation: \(String(describing: metadata.orientation))")
            print("originalDate: \(String(describing: metadata.originalDate?.description))")
            print("title: \(String(describing: metadata.title))")
            print("metadataDictionary: \(String(describing: metadata.metadataDictionary))")
            print("End of \(title) *************")
        }
    }
}
