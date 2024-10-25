//
//  GenericTextLineScannerViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 07.06.21.
//

import UIKit
import ScanbotSDK

class GenericTextLineScannerViewController: UIViewController {
    
    // The instance of the scanner view controller.
    var recognizerController: SBSDKGenericTextLineScannerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the default SBSDKGenericTextLineRecognizerConfiguration object.
        let configuration = SBSDKGenericTextLineScannerConfiguration()
        
        // Create the SBSDKGenericTextLineRecognizerViewController instance.
        self.recognizerController = SBSDKGenericTextLineScannerViewController(parentViewController: self,
                                                                              parentView: self.view,
                                                                              configuration: configuration,
                                                                              delegate: self)
    }
}

extension GenericTextLineScannerViewController: SBSDKGenericTextLineScannerViewControllerDelegate {
    func textLineScannerViewController(_ controller: SBSDKGenericTextLineScannerViewController,
                                       didValidate result: SBSDKGenericTextLineScannerResult) {
        // Process the recognized result.
    }
}
