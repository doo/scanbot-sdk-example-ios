//
//  UsecaseBarcodeBatch.swift
//  ReadyToUseUIDemo
//
//  Created by Yevgeniy Knizhnik on 13.08.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

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
        
        configuration.behaviorConfiguration.engineMode = engineMode
        if let additionalParameters = additionalParameters {
            configuration.behaviorConfiguration.additionalDetectionParameters = additionalParameters
        }
        configuration.behaviorConfiguration.acceptedMachineCodeTypes = SBSDKBarcodeType.commonTypes()
        
        let scanner = SBSDKUIBarcodesBatchScannerViewController.createNew(with: configuration,
                                                                          andDelegate: self)
        
        presentViewController(scanner)
    }
    
    func barcodesBatchScannerViewController(_ viewController: SBSDKUIBarcodesBatchScannerViewController,
                                            didFinishWith barcodeResults: [SBSDKUIBarcodeMappedResult]) {
        if !barcodeResults.isEmpty {
            if let navigationController = presenter as? UINavigationController {
                let controller = BarcodeResultListViewController.make(with: barcodeResults.compactMap({ $0.barcode }))
                navigationController.pushViewController(controller, animated: true)
            }
            didFinish()
        }
    }
}
