//
//  EhicDetectionOnImage.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 27.03.23.


import Foundation
import ScanbotSDK
    
func recognizeEhicOnImage() {
    
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
    
    // Use the builder to construct the generic document configuration to recognize european
    // health insurance card.
    let builder = SBSDKGenericDocumentRecognizerConfigurationBuilder()
    
    // Set the accepted document types as european health insurance card.
    builder.setAcceptedDocumentTypes([SBSDKDocumentsModelRootType.europeanHealthInsuranceCard])
    
    // Set the ehic configuration.
    builder.setEuropeanHealthInsuranceCardConfiguration(ehicConfiguration)
    
    // Get an instance of the constructed generic document configuration.
    let configuration = builder.buildConfiguration()
    
    // Create an instance of `SBSDKGenericDocumentRecognizer`.
    let recognizer = SBSDKGenericDocumentRecognizer(configuration: configuration)
    
    // Run the recognizer on the image.
    let result = recognizer.recognizeDocument(on: image)
    
    
    // Process the result.
    
    // Get the status
    let status = result?.status
    
    // Get the detection result.
    let detectionResult = result?.documentDetectionResult
    
    // Get the cropped image.
    let croppedImage = result?.croppedImage?.toUIImage()
    
    // Access the documents fields directly by iterating over the documents fields.
    if let fields = result?.document?.fields.compactMap({ "\($0.type.displayText ?? ""): \($0.value?.text ?? "")" }) {
        print(fields.joined(separator: "\n"))
    }
}
