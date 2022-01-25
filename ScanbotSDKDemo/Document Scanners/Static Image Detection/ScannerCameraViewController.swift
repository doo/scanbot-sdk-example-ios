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

final class ScannerCameraViewController: UIViewController, SBSDKScannerViewControllerDelegate {
    
    weak var delegate: ScannerCameraViewControllerDelegate?
    private var scanner: SBSDKScannerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanner = SBSDKScannerViewController(parentViewController: self, imageStorage: nil)
    }
    
    @IBAction private func cancelButtonDidPress(_ sender: Any?) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func scannerController(_ controller: SBSDKScannerViewController, didCapture image: UIImage) {
        delegate?.cameraViewController(self, didCapture: image)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
