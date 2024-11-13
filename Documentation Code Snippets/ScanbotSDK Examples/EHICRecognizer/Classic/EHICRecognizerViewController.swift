//
//  EHICRecognizerViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 25.10.21.
//

import UIKit
import ScanbotSDK

class EHICRecognizerViewController: UIViewController {
    
    // The instance of the recognizer view controller.
    private var recognizerViewController: SBSDKGenericDocumentRecognizerViewController?
    
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
        
        // Use the builder to construct the generic document configuration to detect european
        // health insurance card.
        let builder = SBSDKGenericDocumentRecognizerConfigurationBuilder()
        
        // Set the accepted document types as european health insurance card.
        builder.setAcceptedDocumentTypes([SBSDKDocumentsModelRootType.europeanHealthInsuranceCard])
        
        // Set the ehic configuration.
        builder.setEuropeanHealthInsuranceCardConfiguration(ehicConfiguration)
        
        // Get an instance of the constructed generic document configuration.
        let configuration = builder.buildConfiguration()
        
        // Create the `SBSDKGenericDocumentRecognizerViewController` instance and embed it.
        self.recognizerViewController = SBSDKGenericDocumentRecognizerViewController(parentViewController: self,
                                                                                     parentView: self.view,
                                                                                     configuration: configuration,
                                                                                     delegate: self)
    }
}

extension EHICRecognizerViewController: SBSDKGenericDocumentRecognizerViewControllerDelegate {
    
    func documentRecognizerViewController(_ viewController: SBSDKGenericDocumentRecognizerViewController,
                                          didRecognize result: SBSDKGenericDocumentRecognitionResult,
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
