//
//  UsecaseScanTextData.swift
//  ReadyToUseUIDemo
//
//  Created by Yevgeniy Knizhnik on 30.09.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class UsecaseScanTextData: Usecase, SBSDKUITextDataScannerViewControllerDelegate {
    override func start(presenter: UIViewController) {
        super.start(presenter: presenter)
        
        let configuration = SBSDKUITextDataScannerConfiguration.default()
        configuration.textConfiguration.cancelButtonTitle = "Done"
        let step = SBSDKUITextDataScannerStep()
        
        let scanner = SBSDKUITextDataScannerViewController.createNew(with: configuration,
                                                                     recognitionStep: step,
                                                                     andDelegate: self)
        
        presentViewController(scanner)
    }
    
    func textLineRecognizerViewController(_ viewController: SBSDKUITextDataScannerViewController,
                                          didFinish step: SBSDKUITextDataScannerStep,
                                          with result: SBSDKUITextDataScannerStepResult) {
        
        guard let text = result.text, text.count > 0, viewController.isRecognitionEnabled == true else {
            return
        }
        let message = text
        let title = "Text found"
        
        UIAlertController.showInfoAlert(title, message: message, presenter: viewController, completion: nil)
    }
    
    func textLineRecognizerViewControllerDidCancel(_ viewController: SBSDKUITextDataScannerViewController) {
        didFinish()
    }
}
