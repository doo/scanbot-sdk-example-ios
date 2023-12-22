//
//  UsecaseScanGenericDocument.swift
//  ReadyToUseUIDemo
//
//  Created by Yevgeniy Knizhnik on 13.08.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class UsecaseScanGenericDocument: Usecase, SBSDKUIGenericDocumentRecognizerViewControllerDelegate {
    
    private let documentType: SBSDKUIDocumentType
    
    init(documentType: SBSDKUIDocumentType) {
        self.documentType = documentType
        super.init()
    }
    
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        
        let configuration = SBSDKUIGenericDocumentRecognizerConfiguration.defaultConfiguration
        configuration.textConfiguration.cancelButtonTitle = "Done"
        configuration.behaviorConfiguration.documentType = self.documentType
        
        let scanner = SBSDKUIGenericDocumentRecognizerViewController.create(configuration: configuration, delegate: self)
        
        presentViewController(scanner)
    }
    
    func genericDocumentRecognizerViewController(_ viewController: SBSDKUIGenericDocumentRecognizerViewController,
                                                 didFinishWith documents: [SBSDKGenericDocument]) {
        if !documents.isEmpty {
            if let navigationController = presenter as? UINavigationController {
                let controller = GenericDocumentResultListViewController.make(with: documents)
                navigationController.pushViewController(controller, animated: true)
            }
            didFinish()
        }
    }
}
