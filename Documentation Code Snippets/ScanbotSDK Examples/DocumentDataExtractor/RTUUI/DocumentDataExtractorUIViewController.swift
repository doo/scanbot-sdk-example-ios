//
//  DocumentDataExtractorUIViewController.swift
//  ScanbotSDK Examples
//
//  Created by Sebastian Husche on 06.05.21.
//

import UIKit
import ScanbotSDK

// The view controller that presents the document extractor screen.
class DocumentDataExtractorUIViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUIDocumentDataExtractorConfiguration.defaultConfiguration
        
        // Customize the behavior, user interface and text.
        
        // Behavior configuration:
        // Select one of the following document types:
        // German ID card. Front and/or back side.
        configuration.behaviorConfiguration.documentType = SBSDKUIDocumentType.idCardFrontBackDE
        
        // Or German driver's license. Front and/or back side.
        // configuration.behaviorConfiguration.documentType = SBSDKUIDocumentType.driverLicenseFrontBackDE()
        
        // Or German passport. Single sided.
        // configuration.behaviorConfiguration.documentType = SBSDKUIDocumentType.passportDE()
        
        // Select the field types that should be excluded from the extraction process.
        configuration.behaviorConfiguration.excludedFieldTypes = [SBSDKDocumentsModelConstants.mrzGenderFieldNormalizedName,
                                                                  SBSDKDocumentsModelConstants.mrzIssuingAuthorityFieldNormalizedName,
                                                                  SBSDKDocumentsModelConstants.deIdCardFrontNationalityFieldNormalizedName]
        
        // Turn the flashlight on/off.
        configuration.behaviorConfiguration.isFlashEnabled = false
        
        
        // UI configuration:
        // configure various colors.
        configuration.uiConfiguration.detailsBackgroundColor = UIColor.darkGray
        configuration.uiConfiguration.detailsSectionHeaderBackgroundColor = UIColor.darkGray
        
        // Customize the visibility of certain fields in the extracted fields list.
        // Print the field type visibilities, if needed.
        // print("\(configuration.uiConfiguration.fieldTypeVisibilities)")
        
        // Always show the eye-color field in the extracted fields list.
        configuration.uiConfiguration.fieldTypeVisibilities?["DeIdCardBack.EyeColor"] = .alwaysVisible
        // Show the categories field in the extracted fields list if the field has a value, otherwise it is hidden.
        configuration.uiConfiguration.fieldTypeVisibilities?["DeDriverLicenseFront.LicenseCategories"] = .visibleIfNotEmpty
        
        
        // Text configuration:
        // customize UI elements' texts.
        configuration.textConfiguration.cancelButtonTitle = "Abort"
        configuration.textConfiguration.clearButtonTitle = "Reset"
        
        // Customize document type and field type names. Used also for internationalisation.
        // Print the document type texts if needed.
        // print("\(configuration.textConfiguration.documentTypeDisplayTexts)")
        
        // Change/localize the display text for the front side of a German ID card.
        configuration.textConfiguration.documentTypeDisplayTexts["DeIdCardFront"] = "Personalausweis (Vorderseite)"
        
        // Print the field type texts if needed.
        // print("\(configuration.textConfiguration.fieldTypeDisplayTexts)")
        // Change/localize the display text for the surname field on the front side of a German ID card.
        configuration.textConfiguration.fieldTypeDisplayTexts["DeDriverLicenseFront.Surname"] = "Nachname"
        
        // Present the view controller modally.
        SBSDKUIDocumentDataExtractorViewController.present(on: self,
                                                           // Pass the configuration.
                                                           configuration: configuration,
                                                           //Set the delegate
                                                           delegate: self)
    }
}

extension DocumentDataExtractorUIViewController: SBSDKUIDocumentDataExtractorViewControllerDelegate {
    
    // The delegate function implementation.
    func documentDataExtractorViewController(_ viewController: SBSDKUIDocumentDataExtractorViewController, 
                                             didFinishWith results: [SBSDKDocumentDataExtractionResult]) {
        
        // Get the first document. In case of multiple documents, e.g. front side and back side, you need to
        // handle all of them.
        guard let document = results.first?.document else {
            return
        }
        
        // Access the document's fields directly by iterating over the document's fields.
        for field in document.fields {
            // Print field type name, field text and field confidence to the console.
            print("\(field.type.name) = \(field.value?.text ?? "") (Confidence: \(field.value?.confidence ?? 0.0)")
        }
        
        // Or get a field by its name.
        if let nameField = document.field(by: "Surname") {
            // Access various properties of the field.
            let fieldTypeName = nameField.type.name
            let fieldValue = nameField.value?.text
            let confidence = nameField.value?.confidence
        }
        
        // Or create a wrapper for the document if needed.
        // You must cast it to the specific wrapper subclass.
        if let wrapper = document.wrap() as? SBSDKDocumentsModelDeIdCardFront {
            // Access the document's fields easily through the wrapper.
            let fieldTypeName = wrapper.surname?.type.name
            let fieldValue = wrapper.surname?.value?.text
            let confidence = wrapper.surname?.value?.confidence
        }
    }
}
