//
//  DocumentScannerSwiftViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 10.06.21.
//

import UIKit
import ScanbotSDK

class DocumentScannerSwiftViewController: UIViewController {

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

extension DocumentScannerSwiftViewController: SBSDKDocumentScannerViewControllerDelegate {
    func documentScannerViewController(_ controller: SBSDKDocumentScannerViewController,
                                       didSnapDocumentImage documentImage: UIImage,
                                       on originalImage: UIImage,
                                       with result: SBSDKDocumentDetectorResult?, autoSnapped: Bool) {
        // Process the detected document.
    }
}
