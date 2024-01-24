//
//  VINDemoViewController.swift
//  ScanbotSDKDemo
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
        
        let configuration = SBSDKVehicleIdentificationNumberScannerConfiguration.defaultConfiguration
        
        scannerViewController = SBSDKVINScannerViewController(parentViewController: self,
                                                              parentView: cameraContainer,
                                                              configuration: configuration,
                                                              delegate: self)
    }
    
    private func show(result: SBSDKVehicleIdentificationNumberScannerResult) {
        resultLabel.text = result.text
    }
}

extension VINDemoViewController: SBSDKVINScannerViewControllerDelegate {
    
    func vinScannerViewControllerShouldDetect(_ controller: SBSDKVINScannerViewController) -> Bool {
        return true
    }
    
    func vinScannerViewController(_ controller: SBSDKVINScannerViewController,
                                  didScanValidResult result: SBSDKVehicleIdentificationNumberScannerResult) {
        self.show(result: result)
    }
}
