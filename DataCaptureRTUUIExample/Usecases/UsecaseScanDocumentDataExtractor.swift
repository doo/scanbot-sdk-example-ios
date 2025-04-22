//
//  UsecaseScanDocumentDataExtractor.swift
//  DataCaptureRTUUIExample
//
//  Created by Yevgeniy Knizhnik on 13.08.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class UsecaseScanDocumentDataExtractor: Usecase, SBSDKUIDocumentDataExtractorViewControllerDelegate {
    
    private let documentType: SBSDKUIDocumentType
    
    init(documentType: SBSDKUIDocumentType) {
        self.documentType = documentType
        super.init()
    }
    
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        
        let configuration = SBSDKUIDocumentDataExtractorConfiguration.defaultConfiguration
        configuration.textConfiguration.cancelButtonTitle = "Done"
        configuration.behaviorConfiguration.documentType = self.documentType
        
        let scanner = SBSDKUIDocumentDataExtractorViewController.create(configuration: configuration, delegate: self)
        
        presentViewController(scanner)
    }
    
    func documentDataExtractorViewController(_ viewController: SBSDKUIDocumentDataExtractorViewController,
                                                 didFinishWith results: [SBSDKDocumentDataExtractionResult]) {
        if !results.isEmpty {
            if let navigationController = presenter as? UINavigationController {
                let controller = DocumentDataExtractorResultListViewController.make(with: results)
                navigationController.pushViewController(controller, animated: true)
            }
            didFinish()
        }
    }
}
