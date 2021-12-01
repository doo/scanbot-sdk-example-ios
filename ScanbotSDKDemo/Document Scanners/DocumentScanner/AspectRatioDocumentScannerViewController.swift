//
//  AspectRatioDocumentScannerViewController.swift
//  ScanbotSDKDemo
//
//  Created by Dmytro Makarenko on 1/14/19.
//  Copyright © 2019 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class AspectRatioDocumentScannerViewController: DocumentScannerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scannerViewController?.requiredAspectRatios = [SBSDKAspectRatio(width: 21, andHeight: 29.7)] // DIN A4
        scannerViewController?.finderMode = .aspectRatioAlways
    }
    
    override func scannerController(_ controller: SBSDKScannerViewController,
                                    didCaptureDocumentImage documentImage: UIImage) {
        documentImageStorage.add(documentImage)
        performSegue(withIdentifier: "documentReviewSegue", sender: nil)
    }
}
