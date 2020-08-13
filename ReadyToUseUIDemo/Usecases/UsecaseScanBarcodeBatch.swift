//
//  UsecaseBarcodeBatch.swift
//  ReadyToUseUIDemo
//
//  Created by Yevgeniy Knizhnik on 13.08.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

import Foundation

class UsecaseScanBarcodeBatch: Usecase, SBSDKUIBarcodesBatchScannerViewControllerDelegate {
    
    override func start(presenter: UIViewController) {

        super.start(presenter: presenter)

        let configuration = SBSDKUIBarcodesBatchScannerConfiguration.default()
        configuration.textConfiguration.cancelButtonTitle = "Done"
        
        let scanner = SBSDKUIBarcodesBatchScannerViewController.createNew(withAcceptedMachineCodeTypes: SBSDKBarcodeType.commonTypes(),
                                                                          configuration: configuration,
                                                                          andDelegate: self)
        
        self.presentViewController(scanner)
    }
    
    func barcodesBatchScannerViewController(_ viewController: SBSDKUIBarcodesBatchScannerViewController,
                                            didFinishWith barcodeResults: [SBSDKUIBarcodeMappedResult]) {
        self.didFinish()
    }
}
