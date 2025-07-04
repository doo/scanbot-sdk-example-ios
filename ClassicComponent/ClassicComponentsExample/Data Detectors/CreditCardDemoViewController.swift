//
//  CreditCardDemoViewController.swift
//  ClassicComponentsExample
//
//  Created by Seifeddine Bouzid on 07.11.24.
//  Copyright © 2024 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class CreditCardDemoViewController: UIViewController {
    
    private var scannerViewController: SBSDKCreditCardScannerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        scannerViewController = SBSDKCreditCardScannerViewController(parentViewController: self,
                                                                     parentView: view,
                                                                     configuration: SBSDKCreditCardScannerConfiguration(),
                                                                     delegate: self)
    }
    
    private func show(result: SBSDKCreditCardScanningResult) {
        
        let resultMessage = result.stringRepresentation
        
        let alert = UIAlertController(title: "Result",
                                      message: resultMessage,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK",
                                   style: .default) { _ in
            alert.presentedViewController?.dismiss(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension CreditCardDemoViewController: SBSDKCreditCardScannerViewControllerDelegate {
    func creditCardScannerViewController(_ controller: SBSDKCreditCardScannerViewController, 
                                         didScanCreditCard result: SBSDKCreditCardScanningResult) {
        if result.creditCard != nil {
            show(result: result)
        }
    }
}
