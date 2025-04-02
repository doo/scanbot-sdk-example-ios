//
//  VINDemoViewController.swift
//  ClassicComponentsExample
//
//  Created by Rana Sohaib on 21.08.23.
//  Copyright © 2023 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class VINDemoViewController: UIViewController {
    
    @IBOutlet private var cameraContainer: UIView!
    @IBOutlet private var resultLabel: UILabel!
    
    private var scannerViewController: SBSDKVINScannerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = SBSDKVINScannerConfiguration()
        
        scannerViewController = SBSDKVINScannerViewController(parentViewController: self,
                                                              parentView: cameraContainer,
                                                              configuration: configuration,
                                                              delegate: self)
    }
    
    private func show(result: SBSDKVINScannerResult) {
        resultLabel.text = result.textResult.rawText
    }
}

extension VINDemoViewController: SBSDKVINScannerViewControllerDelegate {
    
    func vinScannerViewControllerShouldDetect(_ controller: SBSDKVINScannerViewController) -> Bool {
        return true
    }
    
    func vinScannerViewController(_ controller: SBSDKVINScannerViewController,
                                  didScanVIN result: SBSDKVINScannerResult) {
        self.show(result: result)
    }
}
