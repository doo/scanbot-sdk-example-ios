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
    
    private var scannerViewController: SBSDKCreditCardRecognizerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        scannerViewController = SBSDKCreditCardRecognizerViewController(parentViewController: self,
                                                                        parentView: view,
                                                                        configuration: SBSDKCreditCardRecognizerConfiguration(),
                                                                        delegate: self)
    }
    
    private func show(result: SBSDKCreditCardRecognitionResult) {
        
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

extension CreditCardDemoViewController: SBSDKCreditCardRecognizerViewControllerDelegate {
    func creditCardRecognizerViewController(_ controller: SBSDKCreditCardRecognizerViewController, 
                                            didRecognizeCreditCard result: SBSDKCreditCardRecognitionResult) {
        show(result: result)
    }
}
