//
//  BarcodeScannerWithFinderViewController.swift
//  ClassicComponentsExample
//
//  Created by Danil Voitenko on 29.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class BarcodeScannerWithFinderViewController: BarcodeScannerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let configuration = scannerViewController?.viewFinder else { return }
        
        configuration.aspectRatio = SBSDKAspectRatio(width: 2, height: 1)
        configuration.isViewFinderEnabled = true
    }
}
