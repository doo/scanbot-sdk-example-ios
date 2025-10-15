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
    
    let documentTypes: [String]
    
    init(documentTypes: [String]) {
        self.documentTypes = documentTypes
        super.init()
    }
    
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        let configuration = SBSDKUI2DocumentDataExtractorScreenConfiguration()

        let extractorConfiguration = SBSDKDocumentDataExtractorConfiguration(
            configurations: [SBSDKDocumentDataExtractorCommonConfiguration(
                acceptedDocumentTypes: documentTypes
            )]
        )
        
        configuration.scannerConfiguration = extractorConfiguration
        let extractor = SBSDKUI2DocumentDataExtractorViewController.create(with: configuration) { [weak self] result in
            if let result {
                let title = "Document Data Extractor Result"
                var message = "Recognition Status: \(result.recognitionStatus.stringValue)"
                
                let fields = result.document?.fields.compactMap {
                    "\($0.type.displayText ?? ""): \($0.value?.text ?? "")"
                } ?? []
                message += "\n" + fields.joined(separator: "\n")
                
                UIAlertController.showInfoAlert(title,
                                                message: message,
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
        case .ok:
            return "OK"
        case .okButInvalidDocument:
            return "OKButInvalidDocument"
        case .okButNotConfirmed:
            return "OKButNotConfirmed"
        case .scanningInProgressStillFocusing:
            return "ScanningInProgressStillFocusing"
        case .errorNothingFound:
            return "ErrorNothingFound"
        case .errorBadCrop:
            return "ErrorBadCrop"
        case .errorUnknownDocument:
            return "ErrorUnknownDocument"
        case .errorUnacceptableDocument:
            return "ErrorUnacceptableDocument"
        default:
            return "\(self.rawValue)"
        }
    }
}
