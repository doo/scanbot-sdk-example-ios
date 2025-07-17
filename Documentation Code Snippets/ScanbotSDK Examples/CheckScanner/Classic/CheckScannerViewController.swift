//
//  CheckScannerViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 27.04.22.
//

import UIKit
import ScanbotSDK

class CheckScannerViewController: UIViewController {
    
    // The instance of the scanner view controller.
    private var scannerViewController: SBSDKCheckScannerViewController?
    
    // The label to present the scanning status updates.
    @IBOutlet private var statusLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a configuration with `detectAndCropDocument` to extract the check image.
        let configuration = SBSDKCheckScannerConfiguration(documentDetectionMode: .detectAndCropDocument)
        
        // Create the `SBSDKCheckScannerViewController` instance and embed it.
        self.scannerViewController = SBSDKCheckScannerViewController(parentViewController: self,
                                                                     parentView: self.view,
                                                                     configuration: configuration,
                                                                     delegate: self)
        
        // Customize the default accepted check types as needed.
        // For this example we will use the following types of check.
        self.scannerViewController?.acceptedCheckTypes = [.usaCheck, .uaeCheck, .fraCheck, .isrCheck,
                                                          .kwtCheck, .ausCheck, .indCheck, .canCheck]
    }
}

extension CheckScannerViewController: SBSDKCheckScannerViewControllerDelegate {
    
    func checkScannerViewController(_ controller: SBSDKCheckScannerViewController,
                                    didScanCheck result: SBSDKCheckScanningResult) {
        // Process the scanned result.
        
        // Get the cropped image.
        let croppedImage = result.croppedImage?.toUIImage()
    }
    
    func checkScannerViewController(_ controller: SBSDKCheckScannerViewController,
                                    didChangeState state: SBSDKCheckScannerState) {
        
        // Update status label according to status
        switch state {
        case .searching:
            self.statusLabel?.text = "Looking for the check"
        case .scanning:
            self.statusLabel?.text = "Scanning the check"
        case .capturing:
            self.statusLabel?.text = "Capturing the check"
        case .energySaving:
            self.statusLabel?.text = "Energy saving mode"
        case .paused:
            self.statusLabel?.text = "Recognition paused"
        @unknown default:
            fatalError()
        }
    }
}
