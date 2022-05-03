//
//  BarcodeScannerWithFinderViewController.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 29.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class BarcodeScannerWithFinderViewController: BarcodeScannerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let configuration = scannerViewController?.viewFinderConfiguration {
            configuration.aspectRatio = SBSDKAspectRatio(width: 2, andHeight: 1)
            configuration.isViewFinderEnabled = true
            scannerViewController?.viewFinderConfiguration = configuration
        }
    }
}
