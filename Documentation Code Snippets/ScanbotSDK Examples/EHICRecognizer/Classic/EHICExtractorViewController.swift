//
//  EHICExtractorViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 25.10.21.
//

import UIKit
import ScanbotSDK

class EHICExtractorViewController: UIViewController {
    
    // The instance of the extractor view controller.
    private var extractorViewController: SBSDKDocumentDataExtractorViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the default configuration.
        let ehicConfiguration = SBSDKEuropeanHealthInsuranceCardConfiguration()
        
        // Modify the configuration to your needs.
        
        // Although optional, but you can set the expected country if needed.
        // If this is set, then the validation rules for the given country are used.
        // If the expected country cannot be inferred or the inferred country doesn't match
        // the given country, the result will be IncompleteValidation.
        ehicConfiguration.expectedCountry = .germany
        
        // Use the builder to construct the document data extractor configuration to detect european
        // health insurance card.
        let builder = SBSDKDocumentDataExtractorConfigurationBuilder()
        
        // Set the accepted document types as european health insurance card.
        builder.setAcceptedDocumentTypes([SBSDKDocumentsModelRootType.europeanHealthInsuranceCard])
        
        // Set the ehic configuration.
        builder.setEuropeanHealthInsuranceCardConfiguration(ehicConfiguration)
        
        // Get an instance of the constructed document data extractor configuration.
        let configuration = builder.buildConfiguration()
        
        // Create the `SBSDKGenericDocumentRecognizerViewController` instance and embed it.
        self.extractorViewController = SBSDKDocumentDataExtractorViewController(parentViewController: self,
                                                                                parentView: self.view,
                                                                                configuration: configuration,
                                                                                delegate: self)
    }
}

extension EHICExtractorViewController: SBSDKDocumentDataExtractorViewControllerDelegate {
    
    func documentDataExtractorViewController(_ viewController: SBSDKDocumentDataExtractorViewController,
                                             didExtract result: SBSDKDocumentDataExtractionResult,
                                             on image: UIImage) {
        
        // Process the result.
        
        // Get the status
        let status = result.status
        
        // Get the detection result.
        let detectionResult = result.documentDetectionResult
        
        // Get the cropped image.
        let croppedImage = result.croppedImage?.toUIImage()
        
        // Access the documents fields directly by iterating over the documents fields.
        if let fields = result.document?.fields.compactMap({ "\($0.type.displayText ?? ""): \($0.value?.text ?? "")" }) {
            print(fields.joined(separator: "\n"))
        }
    }
}
