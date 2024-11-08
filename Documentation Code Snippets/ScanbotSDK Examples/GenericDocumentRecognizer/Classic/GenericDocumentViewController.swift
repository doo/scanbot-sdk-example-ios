//
//  GenericDocumentViewController.swift
//  ScanbotSDK Examples
//
//  Created by Sebastian Husche on 06.05.21.
//

import UIKit
import ScanbotSDK

// This is a simple, empty view controller which acts as a container and delegate for the SBSDKGenericDocumentRecognizerViewController.
class GenericDocumentViewController: UIViewController, SBSDKGenericDocumentRecognizerViewControllerDelegate {
    
    // The instance of the recognition view controller.
    var recognizerController: SBSDKGenericDocumentRecognizerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Define the types of documents that should be recognized.
        // Recognize all supported document types.
        let allTypes: [SBSDKDocumentsModelRootType] = SBSDKDocumentsModelRootType.allDocumentTypes
        
        // Recognize German ID cards only. Front and/or back side.
        let idCardTypes: [SBSDKDocumentsModelRootType] = [
            SBSDKDocumentsModelRootType.deIdCardFront,
            SBSDKDocumentsModelRootType.deIdCardBack
        ]
        
        // Recognize German passports. Front side only.
        let passportTypes: [SBSDKDocumentsModelRootType] = [
            SBSDKDocumentsModelRootType.dePassport
        ]
        
        // Recognize German driver's licenses only. Front and/or back side.
        let driverLicenseTypes: [SBSDKDocumentsModelRootType] = [
            SBSDKDocumentsModelRootType.deDriverLicenseFront,
            SBSDKDocumentsModelRootType.deDriverLicenseBack
        ];

        // Exclude these field types from the recognition process.
        let excludedTypes = [SBSDKDocumentsModelConstants.mrzGenderFieldNormalizedName,
                             SBSDKDocumentsModelConstants.mrzIssuingAuthorityFieldNormalizedName,
                             SBSDKDocumentsModelConstants.deIdCardFrontNationalityFieldNormalizedName]
        
        // Create a configuration builder.
        let builder = SBSDKGenericDocumentRecognizerConfigurationBuilder()
        
        // Pass the above types here as required.
        builder.setAcceptedDocumentTypes(allTypes)
        
        // Pass the above excluded types here to exclude them from recognition process
        for excludedField in excludedTypes {
            builder.addExcludedField(excludedField)
        }
        
        // Create the SBSDKGenericDocumentRecognizerViewController instance
        // and let it embed into this view controller's view.
        self.recognizerController
            = SBSDKGenericDocumentRecognizerViewController(parentViewController: self,
                                                           //Embed the recognizer in this view controller's view.
                                                           parentView: self.view,
                                                           // Build the configuration.
                                                           configuration: builder.buildConfiguration(),
                                                           // Set the delegate to this view controller.
                                                           delegate: self)
        
        
        // Define additional configuration of the the recognizer view controller.
        
        // Turn the flashlight on/off.
        self.recognizerController.isFlashLightEnabled = false
        
        // Configure the viewfinder.
        // Get current view finder configuration object
        let config = self.recognizerController.viewFinderConfiguration
        
        // Enable the view finder
        config.isViewFinderEnabled = true
        
        // Configure the view finder colors and line properties.
        config.lineColor = UIColor.red
        config.backgroundColor = UIColor.red.withAlphaComponent(0.1)
        config.lineWidth = 2
        config.lineCornerRadius = 8
        
        // Set the view finder configuration to apply it.
        self.recognizerController.viewFinderConfiguration = config
    }
    
    // The delegate implementation of SBSDKGenericDocumentViewController.
    func documentRecognizerViewController(_ controller: SBSDKGenericDocumentRecognizerViewController,
                                          didRecognize result: SBSDKGenericDocumentRecognitionResult,
                                          on image: UIImage) {
        // Access the documents fields directly by iterating over the documents fields.
        result.document?.fields.forEach { field in
            // Print field type name, field text and field confidence to the console.
            print("\(field.type.name) = \(field.value?.text ?? "") (Confidence: \(field.value?.confidence ?? 0.0)")
        }


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
            // Access the documents fields easily through the wrapper.
            let fieldTypeName = wrapper.surname?.type.name
            let fieldValue = wrapper.surname?.value?.text
            let confidence = wrapper.surname?.value?.confidence
        }
    }
}

