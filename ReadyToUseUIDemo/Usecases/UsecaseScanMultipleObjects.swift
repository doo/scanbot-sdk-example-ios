//
//  UsecaseScanMultipleObjects.swift
//  ReadyToUseUIDemo
//
//  Created by Yevgeniy Knizhnik on 27.03.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

import Foundation

class UsecaseScanMultipleObjects: Usecase, SBSDKUIMultipleObjectScannerViewControllerDelegate {
    private let document: SBSDKUIDocument
    
    init(document: SBSDKUIDocument) {
        self.document = document
        super.init()
    }
    
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)

        let configuration = SBSDKUIMultipleObjectScannerConfiguration.default()
        // Customize text resources, behavior and UI:
        //configuration.textConfiguration.cancelButtonTitle = "Abort"
        //configuration.textConfiguration.pageCounterButtonTitle = "%d Pages"
        //configuration.behaviorConfiguration.isAutoSnappingEnabled = false
        //configuration.uiConfiguration.bottomBarBackgroundColor = UIColor.blue

        let scanner = SBSDKUIMultipleObjectScannerViewController.createNew(with: self.document,
                                                                           configuration: configuration,
                                                                           andDelegate: self)

        self.presentViewController(scanner)
    }
    
    func viewControllerShouldCancel(_ viewController: SBSDKUIViewController) -> Bool {
        return true
    }
    
    func viewControllerShouldFinish(_ viewController: SBSDKUIViewController) -> Bool {
        if let presenter = self.presenter, self.document.numberOfPages() > 0 {
            UsecaseBrowseDocumentPages(document: self.document, mode: .scanning).start(presenter: presenter)
            return false
        }
        return true
    }
    
    func multipleObjectScannerViewController(_ viewController: SBSDKUIMultipleObjectScannerViewController,
                                             didFinishWith document: SBSDKUIDocument) {
        
    }
}
