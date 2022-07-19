//
//  CameraViewController.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 24.01.22.
//  Copyright © 2022 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

protocol ScannerCameraViewControllerDelegate: AnyObject {
    func cameraViewController(_ viewController: ScannerCameraViewController, didCapture image: UIImage)
}

final class ScannerCameraViewController: UIViewController, SBSDKDocumentScannerViewControllerDelegate {
    
    weak var delegate: ScannerCameraViewControllerDelegate?
    private var scanner: SBSDKDocumentScannerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanner = SBSDKDocumentScannerViewController(parentViewController: self, parentView: nil, delegate: self)
    }
    
    @IBAction private func cancelButtonDidPress(_ sender: Any?) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func documentScannerViewController(_ controller: SBSDKDocumentScannerViewController,
                                       didSnapDocumentImage documentImage: UIImage,
                                       on originalImage: UIImage,
                                       with result: SBSDKDocumentDetectorResult,
                                       autoSnapped: Bool) {
        
        delegate?.cameraViewController(self, didCapture: documentImage)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
