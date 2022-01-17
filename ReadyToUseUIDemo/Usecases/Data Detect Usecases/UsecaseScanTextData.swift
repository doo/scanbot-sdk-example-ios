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
        
        self.presentViewController(scanner)
    }
    
    func textLineRecognizerViewController(_ viewController: SBSDKUITextDataScannerViewController,
                                          didFinish step: SBSDKUITextDataScannerStep,
                                          with result: SBSDKUITextDataScannerStepResult) {
        
        guard let text = result.text, text.count > 0, viewController.isRecognitionEnabled == true else {
            return
        }
        viewController.isRecognitionEnabled = false

        let message = text
        let title = "Text found"
        
        viewController.isRecognitionEnabled = false
        UIAlertController.showInfoAlert(title, message: message, presenter: viewController) {
            viewController.isRecognitionEnabled = true
        }
    }
    
    func textLineRecognizerViewControllerDidCancel(_ viewController: SBSDKUITextDataScannerViewController) {
        self.didFinish()
    }
}
