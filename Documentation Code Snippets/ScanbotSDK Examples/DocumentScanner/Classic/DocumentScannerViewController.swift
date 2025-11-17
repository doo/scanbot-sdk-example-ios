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

        // Create the SBSDKDocumentScannerViewController instance and embed it.
        self.scannerViewController = SBSDKDocumentScannerViewController(parentViewController: self,
                                                                        parentView: self.view,
                                                                        delegate: self)
    }
}

extension DocumentScannerViewController: SBSDKDocumentScannerViewControllerDelegate {
    
    func documentScannerViewController(_ controller: SBSDKDocumentScannerViewController,
                                       didSnapDocumentImage documentImage: SBSDKImageRef,
                                       on originalImage: SBSDKImageRef,
                                       with result: SBSDKDocumentDetectionResult?,
                                       autoSnapped: Bool) {
        // Process the detected document.
        
        // Convert ImageRef to UIImage if needed.
        let documentUIImage = try? documentImage.toUIImage()
    }
    
    func documentScannerViewController(_ controller: SBSDKDocumentScannerViewController,
                                       didFailScanning error: any Error) {
        // Handle the error.
        print("Error scanning document: \(error.localizedDescription)")
    }
}
