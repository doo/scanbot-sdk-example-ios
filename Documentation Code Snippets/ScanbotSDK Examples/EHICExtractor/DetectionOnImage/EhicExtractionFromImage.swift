//
//  EhicExtractionFromImage.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 27.03.23.


import Foundation
import ScanbotSDK
    
func extractEhicFromImage() {
    
    // The image containing an EU health insurance card.
    guard let image = UIImage(named: "ehicImage") else { return }
    
    // Create the default EHIC configuration.
    let ehicConfiguration = SBSDKEuropeanHealthInsuranceCardConfiguration()
    
    // Modify the configuration if needed.
    
    // Although optional, but you can set the expected country if needed.
    // If this is set, then the validation rules for the given country are used.
    // If the expected country cannot be inferred or the inferred country doesn't match
    // the given country, the result will be IncompleteValidation.
    ehicConfiguration.expectedCountry = .germany
    
    // Create an instance of data extractor configuration for EHIC extraction.
    let configuration = SBSDKDocumentDataExtractorConfiguration(configurations: [ehicConfiguration])
    
    do {
        // Create an instance of extractor.
        let extractor = try SBSDKDocumentDataExtractor(configuration: configuration)
        
        // Create an image ref from UIImage.
        let imageRef = SBSDKImageRef.fromUIImage(image: image)
        
        // Extract the document from the image using the extractor.
        let result = try extractor.run(image: imageRef)
        
        
        // Process the result.
        
        // Get the status
        let status = result.status
        
        // Get the detection result.
        let detectionResult = result.documentDetectionResult
        
        // Get the cropped image.
        let croppedImage = try result.croppedImage?.toUIImage()
        
        // Access the documents fields directly by iterating over the documents fields.
        if let fields = result.document?.fields.compactMap({ "\($0.type.displayText ?? ""): \($0.value?.text ?? "")" }) {
            print(fields.joined(separator: "\n"))
        }
    }
    catch {
        print("Error extracting EHIC: \(error.localizedDescription)")
    }
}
