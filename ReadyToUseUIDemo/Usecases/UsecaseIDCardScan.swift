//
//  UsecaseIDCardScan.swift
//  ReadyToUseUIDemo
//
//  Created by Yevgeniy Knizhnik on 13.08.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

import Foundation

class UsecaseIDCardScan: Usecase, SBSDKUIIDCardScannerViewControllerDelegate {
    
    override func start(presenter: UIViewController) {

        super.start(presenter: presenter)

        let configuration = SBSDKUIIDCardScannerConfiguration.default()
        configuration.textConfiguration.cancelButtonTitle = "Done"
        
        let scanner = SBSDKUIIDCardScannerViewController.createNew(with: configuration, andDelegate: self)
        
        self.presentViewController(scanner)
    }
    
    func idCardScannerViewController(_ viewController: SBSDKUIIDCardScannerViewController,
                                     didFinishWith card: SBSDKIDCard) {
        self.didFinish()
    }
}
