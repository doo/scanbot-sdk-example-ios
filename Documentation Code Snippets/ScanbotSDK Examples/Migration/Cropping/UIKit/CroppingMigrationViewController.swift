//
//  CroppingMigrationViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 28.11.25.
//

import UIKit
import SwiftUI
import ScanbotSDK

// Your ViewController class:
class CroppingMigrationViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func openScannerTapped(_ sender: Any) {
        openCroppingRtuV2()
    }

    func openCroppingRtuV2() {
        let configuration = SBSDKUI2CroppingStandaloneConfiguration(documentUuid: "<documentUuid>",
                                                          pageUuid: "<pageUuid>")

        let croppingView = SBSDKUI2CroppingView(configuration: configuration) { [weak self] result, error in
            guard let self else { return }
            if let error = error {
                if case SBSDKError.operationCanceled = error {
                    print("The operation was cancelled before completion or by the user")
                } else {
                    print("Error editing image: \(error.localizedDescription)")
                }
                return
            }
            guard let result = result else { return }
            do {
                let document = try SBSDKScannedDocument.loadDocument(documentUuid: result.documentUuid)
                let page = try document.page(with: result.pageUuid)
                self.imageView.image = try page.documentImage?.toUIImage()
            } catch {
                print("Error editing image: \(error.localizedDescription)")
            }
        }

        let hostingController = UIHostingController(rootView: croppingView)
        hostingController.modalPresentationStyle = .fullScreen
        present(hostingController, animated: true)
    }
    
    func configExampleCroppingRtuV2() {
        let configuration = SBSDKUI2CroppingStandaloneConfiguration(documentUuid: "<documentUuid>",
                                                          pageUuid: "<pageUuid>")

        // All the colors can be conveniently set using the Palette object:
        configuration.palette.sbColorPrimary = SBSDKUI2Color(uiColor: UIColor.blue)

        // Now all the text resources are in the localization object.
        configuration.localization.croppingTopBarConfirmButtonTitle = "Apply"

        let croppingView = SBSDKUI2CroppingView(configuration: configuration) { _, _ in
            // Handle the result.
        }
        let hostingController = UIHostingController(rootView: croppingView)
        hostingController.modalPresentationStyle = .fullScreen
        present(hostingController, animated: true)
    }
}
