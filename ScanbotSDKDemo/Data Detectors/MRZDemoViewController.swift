//
//  MRZDemoViewController.swift
//  ScanbotSDKDemo
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
                                                              delegate: self)
    }
    
    private func show(result: SBSDKMachineReadableZoneRecognizerResult?) {
        let resultMessage = result?.stringRepresentation() ?? "Nothing detected"
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
                              didDetectMRZ result: SBSDKMachineReadableZoneRecognizerResult) {
        show(result: result)
    }
}
