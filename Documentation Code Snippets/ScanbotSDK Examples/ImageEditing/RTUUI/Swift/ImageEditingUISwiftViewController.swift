//
//  ImageEditingUISwiftViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 09.09.21.
//

import Foundation
import ScanbotSDK

class ImageEditingUISwiftViewController: UIViewController {

    // Page to edit.
    var editingPage: SBSDKDocumentPage?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Check if the page to edit exists.
        guard let page = self.editingPage else { return }

        // Create the default configuration object.
        let configuration = SBSDKUICroppingScreenConfiguration.defaultConfiguration

        // Behavior configuration:
        // e.g disable the rotation feature.
        configuration.behaviorConfiguration.isRotationEnabled = false

        // UI configuration:
        // e.g. configure various colors.
        configuration.uiConfiguration.topBarBackgroundColor = UIColor.red
        configuration.uiConfiguration.topBarButtonsColor = UIColor.white

        // Text configuration:
        // e.g. customize a UI element's text
        configuration.textConfiguration.cancelButtonTitle = "Cancel"

        // Present the recognizer view controller modally on this view controller.
        SBSDKUICroppingViewController.present(on: self,
                                              page: page,
                                              configuration: configuration,
                                              delegate: self)

    }
}

extension ImageEditingUISwiftViewController: SBSDKUICroppingViewControllerDelegate {
    func croppingViewController(_ viewController: SBSDKUICroppingViewController, didFinish changedPage: SBSDKDocumentPage) {
        // Process the edited page and dismiss the editing screen
        viewController.dismiss(animated: true, completion: nil)
    }
}
