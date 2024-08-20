//
//  UsecaseScanFinderDocument.swift
//  DataCaptureRTUUIExample
//
//  Created by Rana Sohaib on 07.03.23.
//  Copyright © 2023 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class UsecaseScanFinderDocument: Usecase, SBSDKUIFinderDocumentScannerViewControllerDelegate {
    
    private let document: SBSDKDocument
    
    init(document: SBSDKDocument) {
        self.document = document
        super.init()
    }
    
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        
        let configuration = SBSDKUIFinderDocumentScannerConfiguration.defaultConfiguration
        configuration.uiConfiguration.finderAspectRatio = SBSDKAspectRatio(width: 1, height: 1.41)
        
        configuration.textConfiguration.cancelButtonTitle = "Done"
        let scanner = SBSDKUIFinderDocumentScannerViewController.create(document: document,
                                                                        configuration: configuration,
                                                                        delegate: self)
        
        presentViewController(scanner)
    }
    
    func finderScanningViewControllerDidCancel(_ viewController: SBSDKUIFinderDocumentScannerViewController) {
        didFinish()
    }
    
    func finderScanningViewController(_ viewController: SBSDKUIFinderDocumentScannerViewController,
                                      didFinishWith document: SBSDKDocument) {
        if let presenter = presenter as? UINavigationController {
            let viewController = DocumentReviewViewController.make(with: document)
            presenter.pushViewController(viewController, animated: true)
        }
    }
}
