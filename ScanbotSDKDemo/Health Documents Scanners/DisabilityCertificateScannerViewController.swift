//
//  DisabilityCertificateScannerViewController.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 30.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class DisabilityCertificateScannerViewController: UIViewController {
    private var scannerViewController: SBSDKScannerViewController?
    private var disabilityCertificateRecognizer = SBSDKDisabilityCertificatesRecognizer()
    private var alertsManager: AlertsManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scannerViewController = SBSDKScannerViewController(parentViewController: self,
                                                           imageStorage: nil)
        scannerViewController?.delegate = self
        scannerViewController?.requiredAspectRatios = [SBSDKAspectRatio(width: 148, andHeight: 210),
                                                       SBSDKAspectRatio(width: 148, andHeight: 105)]
        scannerViewController?.finderMode = .aspectRatioAlways
        
        alertsManager = AlertsManager(presenter: self)
    }
    
    private func show(recognizedResult: SBSDKDisabilityCertificatesRecognizerResult?) {
        if let recognizedResult = recognizedResult, recognizedResult.recognitionSuccessful {
            alertsManager?.showSuccessAlert(with: recognizedResult.stringRepresentation())
        } else {
            alertsManager?.showFailureAlert()
        }
    }
}

extension DisabilityCertificateScannerViewController: SBSDKScannerViewControllerDelegate {
    func scannerController(_ controller: SBSDKScannerViewController, didCaptureDocumentImage documentImage: UIImage) {
        let result = disabilityCertificateRecognizer.recognize(from: documentImage)
        show(recognizedResult: result)
    }
}
