//
//  EHICDemoViewController.swift
//  ClassicComponentsExample
//
//  Created by Danil Voitenko on 24.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class EHICDemoViewController: UIViewController {
    
    @IBOutlet private var statusLabel: UILabel?
    private var scannerViewController: SBSDKHealthInsuranceCardRecognizerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scannerViewController = SBSDKHealthInsuranceCardRecognizerViewController(parentViewController: self,
                                                                              parentView: view,
                                                                              delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let statusView = statusLabel else { return }
        view.bringSubviewToFront(statusView)
    }
    
    private func handle(card: SBSDKEuropeanHealthInsuranceCardRecognitionResult) {
        switch card.status {
        case .success:
            statusLabel?.text = "Card recognized"
            showScannedCard(card)
        case .failedDetection:
            statusLabel?.text = "Please align the back side of the card in the frame to scan it"
        case .incompleteValidation:
            statusLabel?.text = "Card found, please wait..."
        default:
            break
        }
    }
    
    private func showScannedCard(_ card: SBSDKEuropeanHealthInsuranceCardRecognitionResult) {
        let alert = UIAlertController(title: "Result",
                                      message: card.stringRepresentation,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .default) { _ in
            alert.presentedViewController?.dismiss(animated: true)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

extension EHICDemoViewController: SBSDKHealthInsuranceCardRecognizerViewControllerDelegate {
    func healthInsuranceCardRecognizerViewController(_ viewController: SBSDKHealthInsuranceCardRecognizerViewController,
                                                     didScanHealthInsuranceCard card: SBSDKEuropeanHealthInsuranceCardRecognitionResult) {
        DispatchQueue.main.async { [weak self] in
            self?.handle(card: card)
        }
    }
}
