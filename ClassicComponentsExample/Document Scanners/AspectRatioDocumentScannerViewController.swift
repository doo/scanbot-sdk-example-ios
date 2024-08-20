//
//  AspectRatioDocumentScannerViewController.swift
//  ClassicComponentsExample
//
//  Created by Dmytro Makarenko on 1/14/19.
//  Copyright © 2019 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class AspectRatioDocumentScannerViewController: DocumentScannerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let a4AspectRatio = SBSDKAspectRatio(width: 21, height: 29.7)
        scannerViewController?.requiredAspectRatios = [a4AspectRatio] // DIN A4
        
        let configuration = scannerViewController?.viewFinderConfiguration ??
        SBSDKBaseScannerViewFinderConfiguration.defaultConfiguration
        
        configuration.isViewFinderEnabled = true
        configuration.aspectRatio = a4AspectRatio
        scannerViewController?.viewFinderConfiguration = configuration
    }
}
