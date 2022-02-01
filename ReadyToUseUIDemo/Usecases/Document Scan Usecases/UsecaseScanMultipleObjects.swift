//
//  UsecaseScanMultipleObjects.swift
//  ReadyToUseUIDemo
//
//  Created by Yevgeniy Knizhnik on 27.03.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class UsecaseScanMultipleObjects: Usecase,
                                  SBSDKUIMultipleObjectScannerViewControllerDelegate,
                                  UINavigationControllerDelegate {
    private let document: SBSDKUIDocument
    
    init(document: SBSDKUIDocument) {
        self.document = document
        super.init()
    }
    
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)

        let configuration = SBSDKUIMultipleObjectScannerConfiguration.default()
        // Customize text resources, behavior and UI:
//        configuration.textConfiguration.cancelButtonTitle = "Abort"
//        configuration.textConfiguration.objectsCounterButtonTitle = "%d Objects"
//        configuration.behaviorConfiguration.isBatchModeEnabled = false
//        configuration.uiConfiguration.bottomBarBackgroundColor = UIColor.blue

        let scanner = SBSDKUIMultipleObjectScannerViewController.createNew(with: self.document,
                                                                           configuration: configuration,
                                                                           andDelegate: self)

        presentViewController(scanner)
    }
    
    func viewControllerShouldCancel(_ viewController: SBSDKUIViewController) -> Bool {
        return true
    }
    
    func viewControllerShouldFinish(_ viewController: SBSDKUIViewController) -> Bool {
        if document.numberOfPages() > 0 {
            if let navigationController = presenter as? UINavigationController {
                UsecaseBrowseDocumentPages(document: document).start(presenter: navigationController)
                viewController.presentingViewController?.dismiss(animated: true, completion: nil)
                return false
            }
        }
        return true
    }
    
    func multipleObjectScannerViewController(_ viewController: SBSDKUIMultipleObjectScannerViewController,
                                             didFinishWith document: SBSDKUIDocument) {
        
    }
}
