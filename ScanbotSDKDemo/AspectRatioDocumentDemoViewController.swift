//
//  AspectRatioDocumentDemoViewController.swift
//  ScanbotSDKDemo
//
//  Created by Dmytro Makarenko on 1/14/19.
//  Copyright © 2019 doo GmbH. All rights reserved.
//

import UIKit

final class AspectRatioDocumentDemoViewController: DocumentDemoViewController {
    private enum Segue: String {
        case showResult
    }
    
    override func setupScannerViewController() {
        super.setupScannerViewController()
        scannerViewController.requiredAspectRatios = [SBSDKPageAspectRatio(width: 21.0, andHeight: 29.7)] // DIN A4
        scannerViewController.finderMode = .always
    }
    
    override func scannerController(_ controller: SBSDKScannerViewController, didCaptureDocumentImage documentImage: UIImage) {
        super.scannerController(controller, didCaptureDocumentImage: documentImage)
        performSegue(withIdentifier: Segue.showResult.rawValue, sender: documentImage)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let destination = segue.destination as? ScanResultViewController,
            let image = sender as? UIImage
            else { return }
        
        destination.resultImage = image
    }
}
