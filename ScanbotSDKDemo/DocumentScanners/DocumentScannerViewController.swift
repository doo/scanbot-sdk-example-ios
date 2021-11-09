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
    
    private var scanner: SBSDKScannerViewController?
    
    private var documentImageStorage: SBSDKIndexedImageStorage {
        guard let appDocumentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                      in: .userDomainMask).last else {
            fatalError("Failed to fetch document's directory URL")
        }
        let documentImagesDirectory = appDocumentsDirectory.path + "sbsdk-demo-document-images"
        let documentImagesDirectoryUrl = URL(fileURLWithPath: documentImagesDirectory, isDirectory: true)
        let customStorageLocation = SBSDKStorageLocation(baseURL: documentImagesDirectoryUrl)
        guard let documentImageStorage = SBSDKIndexedImageStorage(storageLocation: customStorageLocation) else {
            fatalError("Failed to create image storage")
        }
        return documentImageStorage
    }
    @IBOutlet private var pageCountButton: UIBarButtonItem?
    @IBOutlet private var scannerContainerView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard ScanbotSDK.isLicenseValid() else {
            presentErrorAlert()
            return
        }
        scanner = SBSDKScannerViewController(parentViewController: self,
                                             parentView: self.scannerContainerView,
                                             imageStorage: documentImageStorage,
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
        pageCountButton?.isEnabled = documentImageStorage.imageCount > 0
        pageCountButton?.title = "\(documentImageStorage.imageCount) pages"
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "documentReviewSegue" {
            if documentImageStorage.imageCount > 0 {
                if let controller = segue.destination as? ReviewDocumentsViewController {
                    controller.documentImageStorage = documentImageStorage
                }
            }
        }
    }
}

extension DocumentScannerViewController: SBSDKScannerViewControllerDelegate {
    
    func scannerController(_ controller: SBSDKScannerViewController,
                           didCapture image: UIImage,
                           with info: SBSDKCaptureInfo) {
        documentImageStorage.add(image)
        updateUI()
    }
}

