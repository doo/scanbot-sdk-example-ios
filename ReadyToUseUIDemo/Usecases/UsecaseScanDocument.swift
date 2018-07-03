//
//  UsecaseScanDocument.swift
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 02.07.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import Foundation

class UsecaseScanDocument: Usecase, SBSDKUIDocumentScannerViewControllerDelegate {
    
    private let document: SBSDKUIDocument
    
    init(document: SBSDKUIDocument) {
        self.document = document
        super.init()
    }
    
    override func start(presenter: UIViewController) {

        super.start(presenter: presenter)

        let configuration = SBSDKUIDocumentScannerConfiguration.default()
        let scanner = SBSDKUIDocumentScannerViewController.createNew(with: self.document,
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
    
    func scanningViewController(_ viewController: SBSDKUIDocumentScannerViewController,
                                didFinishWith document: SBSDKUIDocument) {
    }
    
    func scanningViewControllerDidCancel(_ viewController: SBSDKUIDocumentScannerViewController) {
        self.didFinish()
    }

}
