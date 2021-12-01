//
//  LicensePlateDemoViewController.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 26.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class LicensePlateDemoViewController: UIViewController {
    @IBOutlet private var cameraContainer: UIView?
    @IBOutlet private var resultLabel: UILabel?
    @IBOutlet private var resultImageView: UIImageView?
    
    private var scannerViewController: SBSDKLicensePlateScannerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultImageView?.layer.cornerRadius = 8.0
        resultImageView?.layer.masksToBounds = true
        resultImageView?.layer.borderColor = UIColor.black.cgColor
        resultImageView?.layer.borderWidth = 4.0
        resultImageView?.backgroundColor = UIColor.white
        
        show(result: nil)
        scannerViewController = SBSDKLicensePlateScannerViewController(parentViewController: self,
                                                                       parentView: cameraContainer,
                                                                       delegate: self,
                                                                       configuration: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        show(result: nil)
    }
    
    @IBAction private func tapGestureRecognized(_ sender: Any) {
        show(result: nil)
    }
    
    private func show(result: SBSDKLicensePlateScannerResult?) {
        if let result = result {
            let resultString = "Country code: \(result.countryCode)\n" +
            "Plate: \(result.licensePlate)\n" +
            "Confidence: \(result.confidence)"
            
            if resultString != resultLabel?.text {
                resultLabel?.text = resultString
                resultImageView?.image = result.croppedImage
            }
        } else {
            resultLabel?.text = nil
            resultImageView?.image = nil
        }
        resultLabel?.isHidden = result == nil ? true : false
        resultImageView?.isHidden = result == nil ? true : false
    }
}

extension LicensePlateDemoViewController: SBSDKLicensePlateScannerViewControllerDelegate {
    func licensePlateScannerViewController(_ controller: SBSDKLicensePlateScannerViewController,
                                           didRecognizeLicensePlate licensePlateResult: SBSDKLicensePlateScannerResult,
                                           on image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.show(result: licensePlateResult)
        }
    }
}
