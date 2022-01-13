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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scannerViewController = SBSDKScannerViewController(parentViewController: self,
                                                           imageStorage: nil)
        scannerViewController?.delegate = self
        scannerViewController?.requiredAspectRatios = [SBSDKAspectRatio(width: 148, andHeight: 105)]
        scannerViewController?.finderMode = .aspectRatioAlways
    }
    
    private func show(recognizedResult: SBSDKDisabilityCertificatesRecognizerResult?) {
        let alert = UIAlertController(title: "Disability Certificate",
                                      message: "Recognition failed",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        if let recognizedResult = recognizedResult, recognizedResult.recognitionSuccessful {
            alert.message = recognizedResult.stringRepresentation()
            let copiedAlert = UIAlertController(title: "Copied", message: nil, preferredStyle: .alert)
            let copyAction = UIAlertAction(title: "Copy", style: .default) { _ in
                UIPasteboard.general.string = recognizedResult.stringRepresentation()
                alert.dismiss(animated: true) { [weak self] in
                    self?.present(copiedAlert, animated: true) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            copiedAlert.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
            alert.addAction(copyAction)
        }
        present(alert, animated: true, completion: nil)
    }
}

extension DisabilityCertificateScannerViewController: SBSDKScannerViewControllerDelegate {
    func scannerController(_ controller: SBSDKScannerViewController, didCapture image: UIImage) {
        show(recognizedResult:disabilityCertificateRecognizer.recognize(from: image))
    }
}
