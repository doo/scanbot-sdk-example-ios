//
//  CheckViewController.swift
//  ClassicComponentsExample
//
//  Created by Danil Voitenko on 24.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK


final class CheckViewController: UIViewController {
    
    private var recognizerViewController: SBSDKCheckScannerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = SBSDKCheckScannerConfiguration()
        recognizerViewController = SBSDKCheckScannerViewController(parentViewController: self,
                                                                   parentView: view, 
                                                                   configuration: configuration,
                                                                   delegate: self)
    }
    
    private func show(result: SBSDKCheckScanningResult) {
        let alert = UIAlertController(title: "Scanned check",
                                      message: result.toJson(),
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: { _ in
            alert.presentedViewController?.dismiss(animated: true)
        })
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension CheckViewController: SBSDKCheckScannerViewControllerDelegate {
    func checkScannerViewController(_ controller: SBSDKCheckScannerViewController,
                                    didScanCheck result: SBSDKCheckScanningResult,
                                    isHighRes: Bool) {
        if result.status == .success {
            show(result: result)
        }
    }
    
    func checkScannerViewController(_ controller: SBSDKCheckScannerViewController, didFailScanning error: any Error) {
        handleError(error)
    }
    
    func checkScannerViewController(_ controller: SBSDKCheckScannerViewController,
                                    didChangeState state: SBSDKCheckScannerState) { }
}
