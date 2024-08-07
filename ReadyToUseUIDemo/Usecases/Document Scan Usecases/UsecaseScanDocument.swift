//
//  UsecaseScanDocument.swift
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 02.07.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class UsecaseScanDocument: Usecase, SBSDKUIDocumentScannerViewControllerDelegate, UINavigationControllerDelegate {
    
    private let document: SBSDKDocument
    private static var currentSettings: SBSDKUIDocumentScannerSettings?
    
    init(document: SBSDKDocument) {
        self.document = document
        super.init()
    }
    
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)

        let configuration = SBSDKUIDocumentScannerConfiguration.defaultConfiguration
        // Customize text resources, behavior and UI:
        configuration.behaviorConfiguration.ignoreBadAspectRatio = true
        //configuration.textConfiguration.cancelButtonTitle = "Abort"
        //configuration.textConfiguration.pageCounterButtonTitle = "%d Pages"
        //configuration.behaviorConfiguration.isAutoSnappingEnabled = false
        //configuration.uiConfiguration.bottomBarBackgroundColor = UIColor.blue
        // see further configs ...
        
        // Restore last settings
        if let currentSettings = Self.currentSettings {
            configuration.behaviorConfiguration.isFlashEnabled = currentSettings.flashEnabled
            configuration.behaviorConfiguration.isAutoSnappingEnabled = currentSettings.autoSnappingEnabled
            configuration.behaviorConfiguration.isMultiPageEnabled = currentSettings.multiPageEnabled
        }
        
        let scanner = SBSDKUIDocumentScannerViewController.create(document: self.document,
                                                                  configuration: configuration,
                                                                  delegate: self)
        
        presentViewController(scanner)
    }
        
    func scanningViewController(_ viewController: SBSDKUIDocumentScannerViewController,
                                didFinishWith document: SBSDKDocument) {
        
        Self.currentSettings = viewController.currentSettings
        if document.pages.count > 0 {
            if let navigationController = presenter as? UINavigationController {
                UsecaseBrowseDocumentPages(document: self.document).start(presenter: navigationController)
                viewController.presentingViewController?.dismiss(animated: true, completion: nil)
            }
            self.didFinish()
        }
    }
    
    func scanningViewControllerDidCancel(_ viewController: SBSDKUIDocumentScannerViewController) {
        Self.currentSettings = viewController.currentSettings
        didFinish()
    }

}
