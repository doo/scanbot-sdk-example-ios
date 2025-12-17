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
    private var isShowingError = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scannerViewController = SBSDKDocumentScannerViewController(parentViewController: self,
                                                                   parentView: scannerContainerView,
                                                                   delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    private func updateUI() {
        pageCountButton?.isEnabled = Scanbot.isLicenseValid && ImageManager.shared.numberOfImages > 0
        pageCountButton?.title = "\(ImageManager.shared.numberOfImages) pages"
    }
}

extension DocumentScannerViewController: SBSDKDocumentScannerViewControllerDelegate {
    func documentScannerViewController(_ controller: SBSDKDocumentScannerViewController,
                                       didSnapDocumentImage documentImage: SBSDKImageRef,
                                       on originalImage: SBSDKImageRef,
                                       with result: SBSDKDocumentDetectionResult?,
                                       autoSnapped: Bool) {
        do {
            try ImageManager.shared.add(image: originalImage, polygon: result?.polygon ?? SBSDKPolygon())
            updateUI()
        } catch {
            sbsdk_showError(error) { [weak self] _ in
                guard let self else { return }
                self.sbsdk_forceClose(animated: true, completion: nil)
            }
        }
    }
    
    func documentScannerViewController(_ controller: SBSDKDocumentScannerViewController, didFailScanning error: any Error) {
        guard !isShowingError else { return }
        
        isShowingError = true
        sbsdk_showError(error) { [weak self] _ in
            guard let self else { return }
            self.sbsdk_forceClose(animated: true, completion: nil)
        }
    }
    
}

