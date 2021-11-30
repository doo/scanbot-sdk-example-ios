//
//  AspectRatioDocumentScannerViewController.swift
//  ScanbotSDKDemo
//
//  Created by Dmytro Makarenko on 1/14/19.
//  Copyright © 2019 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class AspectRatioDocumentScannerViewController: UIViewController {
    private enum Segue: String {
        case showResult
    }
    private var scannerViewController: SBSDKScannerViewController?
    
    private let documentImageStorage = ImageStorageManager.shared.documentImageStorage
    private let originalImageStorage = ImageStorageManager.shared.originalImageStorage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scannerViewController = SBSDKScannerViewController(parentViewController: self, imageStorage: nil)
        scannerViewController?.requiredAspectRatios = [SBSDKAspectRatio(width: 21, andHeight: 29.7)] // DIN A4
        scannerViewController?.finderMode = .aspectRatioAlways
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ReviewDocumentsViewController {
            controller.documentImageStorage = documentImageStorage
            controller.originalImageStorage = originalImageStorage
        }
    }
}

extension AspectRatioDocumentScannerViewController: SBSDKScannerViewControllerDelegate {
    
    func scannerController(_ controller: SBSDKScannerViewController, didCapture image: UIImage) {
        originalImageStorage.add(image)
    }
    
    func scannerController(_ controller: SBSDKScannerViewController, didCaptureDocumentImage documentImage: UIImage) {
        documentImageStorage.add(documentImage)
        performSegue(withIdentifier: Segue.showResult.rawValue, sender: nil)
    }
}
