//
//  DocumentScannerViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 10.06.21.
//

import UIKit
import ScanbotSDK

class DocumentScannerViewController: UIViewController {

    // The instance of the scanner view controller.
    var scannerViewController: SBSDKDocumentScannerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the SBSDKScannerViewController instance.
        self.scannerViewController = SBSDKDocumentScannerViewController(parentViewController: self,
                                                                        parentView: self.view,
                                                                        delegate: self)
    }

}

extension DocumentScannerViewController: SBSDKDocumentScannerViewControllerDelegate {
    func documentScannerViewController(_ controller: SBSDKDocumentScannerViewController,
                                       didSnapDocumentImage documentImage: UIImage,
                                       on originalImage: UIImage,
                                       with result: SBSDKDocumentDetectionResult?, autoSnapped: Bool) {
        // Process the detected document.
    }
}
