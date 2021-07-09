//
//  UsecaseBarcodeBatch.swift
//  ReadyToUseUIDemo
//
//  Created by Yevgeniy Knizhnik on 13.08.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

import Foundation

class UsecaseScanBarcodeBatch: Usecase, SBSDKUIBarcodesBatchScannerViewControllerDelegate {
    
    private var engineMode: SBSDKBarcodeEngineMode
    private var additionalParameters: SBSDKBarcodeAdditionalParameters?
    
    init(engineMode: SBSDKBarcodeEngineMode = .nextGen,
         additionalParameters: SBSDKBarcodeAdditionalParameters? = nil) {
        self.engineMode = engineMode
        self.additionalParameters = additionalParameters
        super.init()
    }
    
    override func start(presenter: UIViewController) {

        super.start(presenter: presenter)

        let configuration = SBSDKUIBarcodesBatchScannerConfiguration.default()
        configuration.textConfiguration.cancelButtonTitle = "Done"
                
        configuration.behaviorConfiguration.engineMode = self.engineMode
        if let additionalParameters = self.additionalParameters {
            configuration.behaviorConfiguration.additionalDetectionParameters = additionalParameters
        }
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
