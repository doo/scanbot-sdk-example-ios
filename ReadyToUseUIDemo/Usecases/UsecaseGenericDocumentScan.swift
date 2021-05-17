//
//  UsecaseGenericDocumentScan.swift
//  ReadyToUseUIDemo
//
//  Created by Yevgeniy Knizhnik on 13.08.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

import Foundation

class UsecaseGenericDocumentScan: Usecase, SBSDKUIGenericDocumentRecognizerViewControllerDelegate {
    override func start(presenter: UIViewController) {

        super.start(presenter: presenter)

        let configuration = SBSDKUIGenericDocumentRecognizerConfiguration.default()
        configuration.textConfiguration.cancelButtonTitle = "Done"
        
        let scanner = SBSDKUIGenericDocumentRecognizerViewController.createNew(with: configuration, andDelegate: self)
        
        self.presentViewController(scanner)
    }
    
    func genericDocumentRecognizerViewController(_ viewController: SBSDKUIGenericDocumentRecognizerViewController,
                                                 didFinishWith documents: [SBSDKGenericDocument]) {
        self.didFinish()
    }
}
