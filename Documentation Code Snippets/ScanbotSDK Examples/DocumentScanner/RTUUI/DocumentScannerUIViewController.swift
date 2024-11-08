//
//  DocumentScannerUIViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 10.06.21.
//

import UIKit
import ScanbotSDK

class DocumentScannerUIViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }

    func startScanning() {

        // Create the default configuration object.
        let configuration = SBSDKUIDocumentScannerConfiguration.defaultConfiguration

        // Behavior configuration:
        // e.g. enable multi page mode to scan several documents before processing the result.
        configuration.behaviorConfiguration.isMultiPageEnabled = true

        // UI configuration:
        // e.g. configure various colors.
        configuration.uiConfiguration.topBarBackgroundColor = UIColor.red
        configuration.uiConfiguration.topBarButtonsActiveColor = UIColor.white
        configuration.uiConfiguration.topBarButtonsInactiveColor = UIColor.white.withAlphaComponent(0.3)

        // Text configuration:
        // e.g. customize a UI element's text.
        configuration.textConfiguration.cancelButtonTitle = "Cancel"

        // Present the recognizer view controller modally on this view controller.
        SBSDKUIDocumentScannerViewController.present(on: self,
                                                     configuration: configuration,
                                                     delegate: self)
    }
}

extension DocumentScannerUIViewController: SBSDKUIDocumentScannerViewControllerDelegate {
    func scanningViewController(_ viewController: SBSDKUIDocumentScannerViewController,
                                didFinishWith document: SBSDKDocument) {
        // Process the scanned document.
    }
}
