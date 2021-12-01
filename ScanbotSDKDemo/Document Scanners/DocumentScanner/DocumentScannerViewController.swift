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
    
    let documentImageStorage = ImageStorageManager.shared.documentImageStorage
    let originalImageStorage = ImageStorageManager.shared.originalImageStorage
    
    @IBOutlet private var pageCountButton: UIBarButtonItem?
    @IBOutlet private var scannerContainerView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ScanbotSDK.isLicenseValid() else {
            presentErrorAlert()
            return
        }
        scannerViewController = SBSDKScannerViewController(parentViewController: self,
                                             parentView: self.scannerContainerView,
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
        pageCountButton?.isEnabled = ScanbotSDK.isLicenseValid() && documentImageStorage.imageCount > 0
        pageCountButton?.title = "\(documentImageStorage.imageCount) pages"
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if documentImageStorage.imageCount > 0 && originalImageStorage.imageCount > 0 {
            if let controller = segue.destination as? ReviewDocumentsViewController {
                controller.documentImageStorage = documentImageStorage
                controller.originalImageStorage = originalImageStorage
            }
        }
    }
}

extension DocumentScannerViewController: SBSDKScannerViewControllerDelegate {
    func scannerController(_ controller: SBSDKScannerViewController, didCaptureDocumentImage documentImage: UIImage) {
        documentImageStorage.add(documentImage)
        updateUI()
    }
    
    func scannerController(_ controller: SBSDKScannerViewController, didCapture image: UIImage) {
        originalImageStorage.add(image)
    }
}

