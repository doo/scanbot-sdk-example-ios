//
//  DocumentScannerViewController.swift
//  ClassicComponentsExample
//
//  Created by Danil Voitenko on 04.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class DocumentScannerViewController: UIViewController {
    
    var scannerViewController: SBSDKDocumentScannerViewController?
    
    
    @IBOutlet private var pageCountButton: UIBarButtonItem!
    @IBOutlet private var scannerContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard Scanbot.isLicenseValid else {
            presentErrorAlert()
            return
        }
        scannerViewController = SBSDKDocumentScannerViewController(parentViewController: self,
                                                                   parentView: scannerContainerView,
                                                                   delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    private func presentErrorAlert() {
        let alert = UIAlertController(title: "Error",
                                      message: "The ScanbotSDK license has been expired",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .default,
                                      handler: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func updateUI() {
        pageCountButton?.isEnabled = Scanbot.isLicenseValid && ImageManager.shared.numberOfImages > 0
        pageCountButton?.title = "\(ImageManager.shared.numberOfImages) pages"
    }
}

extension DocumentScannerViewController: SBSDKDocumentScannerViewControllerDelegate {
    func documentScannerViewController(_ controller: SBSDKDocumentScannerViewController,
                                       didSnapDocumentImage documentImage: UIImage,
                                       on originalImage: UIImage,
                                       with result: SBSDKDocumentDetectionResult?,
                                       autoSnapped: Bool) {
        ImageManager.shared.add(image: originalImage, polygon: result?.polygon ?? SBSDKPolygon())
        updateUI()
    }
}

