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
    
    private var recognizerViewController: SBSDKCheckRecognizerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recognizerViewController = SBSDKCheckRecognizerViewController(parentViewController: self,
                                                                      parentView: view,
                                                                      delegate: self)
    }
        
    private func show(result: SBSDKCheckRecognitionResult) {
        let alert = UIAlertController(title: "Recognized check",
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

extension CheckViewController: SBSDKCheckRecognizerViewControllerDelegate {
    func checkRecognizerViewController(_ controller: SBSDKCheckRecognizerViewController,
                                       didRecognizeCheck result: SBSDKCheckRecognitionResult) {
        show(result: result)
    }
    
    func checkRecognizerViewController(_ controller: SBSDKCheckRecognizerViewController,
                                       didChangeState state: SBSDKCheckRecognizerState) { }
}
