//
//  UsecaseScanDocumentDataExtractor.swift
//  DataCaptureRTUUIExample
//
//  Created by Daniil Voitenko on 18.06.25.
//  Copyright © 2025 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class UsecaseScanDocumentDataExtractor: Usecase {
    
    let documentTypes: [SBSDKDocumentsModelRootType]
    
    init(documentTypes: [SBSDKDocumentsModelRootType]) {
        self.documentTypes = documentTypes
        super.init()
    }
    
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        
        let configuration = SBSDKUI2DocumentDataExtractorScreenConfiguration()
        let builder = SBSDKDocumentDataExtractorConfigurationBuilder()
        builder.setAcceptedDocumentTypes(documentTypes)
        
        configuration.scannerConfiguration = builder.buildConfiguration()
        let extractor = SBSDKUI2DocumentDataExtractorViewController.create(with: configuration) { [weak self] result in
            if let result {
                let title = "Document Data Extractor Result"
                var message = "Recognition Status: \(result.recognitionStatus.stringValue)"
                
                let fields = result.document?.fields.compactMap {
                    "\($0.type.displayText ?? ""): \($0.value?.text ?? "")"
                } ?? []
                message += "\n" + fields.joined(separator: "\n")
                
                UIAlertController.showInfoAlert(title,
                                                message: result.description,
                                                presenter: presenter, completion: nil)
            } else {
                self?.didFinish()
            }
        }
        
        presentViewController(extractor)
    }
}

extension SBSDKDocumentDataExtractionStatus {
    var stringValue: String {
        switch self {
        case .success:
            return "Success"
        case .errorNothingFound:
            return "ErrorNothingFound"
        case .incompleteValidation:
            return "Incomplete"
        default:
            return "\(self.rawValue)"
        }
    }
}
