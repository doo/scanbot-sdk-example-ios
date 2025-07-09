//
//  DocumentDataExtractorViewController.swift
//  ScanbotSDK Examples
//
//  Created by Sebastian Husche on 06.05.21.
//

import UIKit
import ScanbotSDK

// This is a simple, empty view controller which acts as a container and delegate for the `SBSDKDocumentDataExtractorViewController`.
class DocumentDataExtractorViewController: UIViewController {
    
    // The instance of the view controller.
    var extractorController: SBSDKDocumentDataExtractorViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Define the types of documents that should be extracted.
        // extract all supported document types.
        let allTypes: [SBSDKDocumentsModelRootType] = SBSDKDocumentsModelRootType.allDocumentTypes
        
        // Extracts German ID cards only. Front and/or back side.
        let idCardTypes: [SBSDKDocumentsModelRootType] = [
            SBSDKDocumentsModelRootType.deIdCardFront,
            SBSDKDocumentsModelRootType.deIdCardBack
        ]
        
        // Extracts German passports. Front side only.
        let passportTypes: [SBSDKDocumentsModelRootType] = [
            SBSDKDocumentsModelRootType.dePassport
        ]
        
        // Extracts European driver's licenses only. Front and/or back side.
        let driverLicenseTypes: [SBSDKDocumentsModelRootType] = [
            SBSDKDocumentsModelRootType.europeanDriverLicenseFront,
            SBSDKDocumentsModelRootType.europeanDriverLicenseBack
        ];
        
        // Exclude these field types from the extraction process.
        let excludedTypes = [SBSDKDocumentsModelConstants.mrzGenderFieldNormalizedName,
                             SBSDKDocumentsModelConstants.mrzIssuingAuthorityFieldNormalizedName,
                             SBSDKDocumentsModelConstants.deIdCardFrontNationalityFieldNormalizedName]
        
        // Create a configuration builder.
        let builder = SBSDKDocumentDataExtractorConfigurationBuilder()
        
        // Pass the above types here as required.
        builder.setAcceptedDocumentTypes(allTypes)
        
        // Enable the crops image extraction.
        builder.setReturnCrops(true)
        
        // Pass the above excluded types here to exclude them from the extraction process
        for excludedField in excludedTypes {
            builder.addExcludedField(excludedField)
        }
        
        // Create the `SBSDKDocumentDataExtractorViewController` instance and
        // embed it into this view controller's view.
        self.extractorController
        = SBSDKDocumentDataExtractorViewController(parentViewController: self,
                                                   //Embed the extractor in this view controller's view.
                                                   parentView: self.view,
                                                   // Build the configuration.
                                                   configuration: builder.buildConfiguration(),
                                                   // Set the delegate to this view controller.
                                                   delegate: self)
        
        
        // Define additional configuration of the extractor view controller.
        
        // Turn the flashlight on/off.
        self.extractorController.isFlashLightEnabled = false
        
        // Configure the viewfinder.
        // Get current view finder configuration object
        let config = self.extractorController.viewFinderConfiguration
        
        // Enable the view finder
        config.isViewFinderEnabled = true
        
        // Configure the view finder colors and line properties.
        config.lineColor = UIColor.red
        config.backgroundColor = UIColor.red.withAlphaComponent(0.1)
        config.lineWidth = 2
        config.lineCornerRadius = 8
        
        // Set the view finder configuration to apply it.
        self.extractorController.viewFinderConfiguration = config
    }
}

// The delegate implementation of `SBSDKDocumentDataExtractorViewControllerDelegate`.
extension DocumentDataExtractorViewController: SBSDKDocumentDataExtractorViewControllerDelegate {
    
    func documentDataExtractorViewController(_ controller: SBSDKDocumentDataExtractorViewController,
                                             didExtract result: SBSDKDocumentDataExtractionResult,
                                             on image: UIImage) {
        
        // Access the document's fields directly by iterating over the document's fields.
        result.document?.fields.forEach { field in
            // Print field type name, field text and field confidence to the console.
            print("\(field.type.name) = \(field.value?.text ?? "") (Confidence: \(field.value?.confidence ?? 0.0)")
        }
        
        
        // Get the cropped image.
        let croppedImage = result.croppedImage?.toUIImage()
        
        // Or get a field by its name.
        if let nameField = result.document?.field(by: "Surname") {
            // Access various properties of the field.
            let fieldTypeName = nameField.type.name
            let fieldValue = nameField.value?.text
            let confidence = nameField.value?.confidence
        }
        
        
        // Or create a wrapper for the document if needed.
        // You must cast it to the specific wrapper subclass.
        if let wrapper = result.document?.wrap() as? SBSDKDocumentsModelDeIdCardFront {
            // Access the document's fields easily through the wrapper.
            let fieldTypeName = wrapper.surname?.type.name
            let fieldValue = wrapper.surname?.value?.text
            let confidence = wrapper.surname?.value?.confidence
        }
        
    }
}
