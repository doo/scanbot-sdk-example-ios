//
//  SinglePageFinderOverlayScanning.swift
//  DocumentScannerRTUUIExample
//
//  Created by Rana Sohaib on 30.08.23.
//

import ScanbotSDK

final class SinglePageFinderOverlayScanning: NSObject, SBSDKUIFinderDocumentScannerViewControllerDelegate {
    
    // The view controller on which the scanner is presented on
    private var presenter: UIViewController?
    
    init(presenter: UIViewController? = nil) {
        self.presenter = presenter
    }
    
    // The scanner view controller calls this delegate method when it has scanned document pages
    // and the scanner view controller has been dismissed
    func finderScanningViewController(_ viewController: SBSDKUIFinderDocumentScannerViewController,
                                      didFinishWith document: SBSDKDocument) {
        
        // Process the document
        let resultViewController = SingleScanResultViewController.make(with: document)
        presenter?.navigationController?.pushViewController(resultViewController, animated: true)
    }
    
    // The scanner view controller calls this delegate method to inform that it has been cancelled and dismissed
    func finderScanningViewControllerDidCancel(_ viewController: SBSDKUIFinderDocumentScannerViewController) {
        
    }
}

extension SinglePageFinderOverlayScanning {
    
    // To hold an instance of the delegate handler
    private static var delegateHandler: SinglePageFinderOverlayScanning?
    
    static func present(presenter: UIViewController) {
        
        // Initialize delegate handler
        delegateHandler = SinglePageFinderOverlayScanning(presenter: presenter)
        
        // Initialize document scanner configuration object using default configurations
        let configuration = SBSDKUIFinderDocumentScannerConfiguration.defaultConfiguration
        
        // Enable Auto Snapping behavior
        configuration.behaviorConfiguration.isAutoSnappingEnabled = true
        
        // Set the aspect ratio for the finder overlay
        configuration.uiConfiguration.finderAspectRatio = SBSDKAspectRatio(width: 3, height: 4)
        
        // Set colors
        configuration.uiConfiguration.topBarButtonsActiveColor = .white
        configuration.uiConfiguration.topBarButtonsInactiveColor = .white
        configuration.uiConfiguration.topBarBackgroundColor = .appAccentColor
        
        // Set the font for the hint text
        configuration.textConfiguration.textHintFontSize = 16.0
        
        // Configure the hint texts for different scenarios
        configuration.textConfiguration.textHintTooDark = "Need more lighting to detect a document"
        configuration.textConfiguration.textHintTooSmall = "Document too small"
        configuration.textConfiguration.textHintNothingDetected = "Could not detect a document"
        
        // Present the document scanner on the presenter (presenter in our case is the UsecasesListTableViewController)
        SBSDKUIFinderDocumentScannerViewController.present(on: presenter,
                                                           configuration: configuration,
                                                           delegate: delegateHandler)
    }
}
