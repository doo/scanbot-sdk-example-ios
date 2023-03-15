//
//  UsecaseScanFinderDocument.swift
//  ReadyToUseUIDemo
//
//  Created by Rana Sohaib on 07.03.23.
//  Copyright © 2023 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class UsecaseScanFinderDocument: Usecase, SBSDKUIFinderDocumentScannerViewControllerDelegate {
    
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        
        let configuration = SBSDKUIFinderDocumentScannerConfiguration.default()
        configuration.uiConfiguration.finderAspectRatio = SBSDKAspectRatio(width: 1, andHeight: 1.41)
        
        configuration.textConfiguration.cancelButtonTitle = "Done"
        
        let scanner = SBSDKUIFinderDocumentScannerViewController.createNew(with: configuration, andDelegate: self)
        
        presentViewController(scanner)
    }
    
    func finderScanningViewControllerDidCancel(_ viewController: SBSDKUIFinderDocumentScannerViewController) {
        didFinish()
    }
    
    func finderScanningViewController(_ viewController: SBSDKUIFinderDocumentScannerViewController,
                                      didFinishWith document: SBSDKUIDocument) {
        if let presenter = presenter as? UINavigationController {
            let viewController = DocumentReviewViewController.make(with: document)
            presenter.pushViewController(viewController, animated: true)
        }
    }
}
