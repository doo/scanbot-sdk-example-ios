//
//  FinderDocumentScannerUISwiftViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 16.02.23.
//

import UIKit
import ScanbotSDK

class FinderDocumentScannerUISwiftViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Start scanning here. Usually this is an action triggered by some button or menu.
        self.startScanning()
    }
    
    func startScanning() {
        
        // Create the default configuration object.
        let configuration = SBSDKUIFinderDocumentScannerConfiguration.defaultConfiguration

        // Behavior configuration:
        // e.g. customize the auto snapping delay.
        configuration.behaviorConfiguration.autoSnappingDelay = 1.0

        // UI configuration:
        // e.g. configure various colors.
        configuration.uiConfiguration.topBarBackgroundColor = UIColor.red
        configuration.uiConfiguration.topBarButtonsActiveColor = UIColor.white
        configuration.uiConfiguration.topBarButtonsInactiveColor = UIColor.white.withAlphaComponent(0.3)

        // Text configuration:
        // e.g. customize a UI element's text.
        configuration.textConfiguration.cancelButtonTitle = "Cancel"

        // Present the recognizer view controller modally on this view controller.
        SBSDKUIFinderDocumentScannerViewController.present(on: self,
                                                           configuration: configuration,
                                                           delegate: self)
    }
}

extension FinderDocumentScannerUISwiftViewController: SBSDKUIFinderDocumentScannerViewControllerDelegate {
    func finderScanningViewController(_ viewController: SBSDKUIFinderDocumentScannerViewController,
                                      didFinishWith document: SBSDKDocument) {
        // Process the scanned document.
    }
}
