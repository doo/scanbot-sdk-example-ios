//
//  MRZDemoViewController.swift
//  ClassicComponentsExample
//
//  Created by Danil Voitenko on 23.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class MRZDemoViewController: UIViewController {
    
    private var scannerViewController: SBSDKMRZScannerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        scannerViewController = SBSDKMRZScannerViewController(parentViewController: self,
                                                              parentView: view, 
                                                              configuration: SBSDKMRZScannerConfiguration(),
                                                              delegate: self)
    }
    
    private func show(result: SBSDKMRZScannerResult?) {

        guard let result, result.success else { return }

        let resultMessage = result.toJson()
        let alert = UIAlertController(title: "Result",
                                      message: resultMessage,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK",
                                   style: .default) { _ in
            alert.presentedViewController?.dismiss(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension MRZDemoViewController: SBSDKMRZScannerViewControllerDelegate {
    func mrzScannerController(_ controller: SBSDKMRZScannerViewController,
                              didScanMRZ result: SBSDKMRZScannerResult) {
        show(result: result)
    }
    
    func mrzScannerController(_ controller: SBSDKMRZScannerViewController, didFailScanning error: any Error) {
        sbsdk_showError(error)
    }
}
