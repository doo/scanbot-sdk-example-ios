//
//  DocumentScannerViewController.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 04.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class DocumentScannerViewController: UIViewController {
    
    var scannerViewController: SBSDKScannerViewController?
    
    
    @IBOutlet private var pageCountButton: UIBarButtonItem?
    @IBOutlet private var scannerContainerView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ScanbotSDK.isLicenseValid() else {
            presentErrorAlert()
            return
        }
        scannerViewController = SBSDKScannerViewController(parentViewController: self,
                                             parentView: scannerContainerView,
                                             imageStorage: nil,
                                             enableQRCodeDetection: false)
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
        pageCountButton?.isEnabled = ScanbotSDK.isLicenseValid() && ImageManager.shared.numberOfImages > 0
        pageCountButton?.title = "\(ImageManager.shared.numberOfImages) pages"
    }
}

extension DocumentScannerViewController: SBSDKScannerViewControllerDelegate {
    
    func scannerController(_ controller: SBSDKScannerViewController,
                           didCapture image: UIImage,
                           with info: SBSDKCaptureInfo) {
        
        ImageManager.shared.add(image: image, polygon: info.detectionResult?.polygon ?? SBSDKPolygon())
        updateUI()
    }
}

