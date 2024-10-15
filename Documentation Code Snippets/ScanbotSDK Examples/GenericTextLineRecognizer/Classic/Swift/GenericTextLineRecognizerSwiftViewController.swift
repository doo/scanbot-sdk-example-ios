//
//  GenericTextLineRecognizerSwiftViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 07.06.21.
//

import UIKit
import ScanbotSDK

class GenericTextLineRecognizerSwiftViewController: UIViewController {

    // The instance of the scanner view controller.
    var recognizerController: SBSDKGenericTextLineRecognizerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the default SBSDKGenericTextLineRecognizerConfiguration object.
        let configuration = SBSDKGenericTextLineRecognizerConfiguration.defaultConfiguration

        // Create the SBSDKGenericTextLineRecognizerViewController instance.
        self.recognizerController = SBSDKGenericTextLineRecognizerViewController(parentViewController: self,
                                                                                 parentView: self.view,
                                                                                 configuration: configuration,
                                                                                 delegate: self)
    }
}

extension GenericTextLineRecognizerSwiftViewController: SBSDKGenericTextLineRecognizerViewControllerDelegate {
    func textLineRecognizerViewController(_ controller: SBSDKGenericTextLineRecognizerViewController,
                                          didValidate result: SBSDKGenericTextLineRecognizerResult) {
        // Process the recognized result.
    }
}
