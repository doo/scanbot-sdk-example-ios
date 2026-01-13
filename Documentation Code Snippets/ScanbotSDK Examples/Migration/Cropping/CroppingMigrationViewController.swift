//
//  CroppingMigrationViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 28.11.25.
//

import UIKit
import ScanbotSDK

// Your ViewController class:
class CroppingMigrationViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func openScannerTapped(_ sender: Any) {
        Task {
            await openCroppingRtuV2()
        }
    }

    func openCroppingRtuV2() async {
        
        let configuration = SBSDKUI2CroppingConfiguration(documentUuid: "<documentUuid>",
                                                          pageUuid: "<pageUuid>")

        // ...screen configuration

        // Present the view controller modally.
        do {
            let result = try await SBSDKUI2CroppingViewController.present(on: self,
                                                                          configuration: configuration)
            // The screen is dismissed without errors.
            // Process the edited page.
            let document = try SBSDKScannedDocument.loadDocument(documentUuid: result.documentUuid)
            let page = try document.page(with: result.pageUuid)
            self.imageView.image = try page.documentImage?.toUIImage()
            
        } catch SBSDKError.operationCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } catch {
            // Any other error
            print("Error editing image: \(error.localizedDescription)")
        }
    }
    
    func configExampleCroppingRtuV2() async {
        
        let configuration = SBSDKUI2CroppingConfiguration(documentUuid: "<documentUuid>",
                                                          pageUuid: "<pageUuid>")

        // All the colors can be conveniently set using the Palette object:
        configuration.palette.sbColorPrimary = SBSDKUI2Color(uiColor: UIColor.blue)

        // Now all the text resources are in the localization object.
        configuration.localization.croppingTopBarConfirmButtonTitle = "Apply"

        // Present the view controller modally.
        do {
            let result = try await SBSDKUI2CroppingViewController.present(on: self,
                                                                          configuration: configuration)
            // Handle the result.
            
        } catch SBSDKError.operationCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } catch {
            // Any other error
            print("Error editing image: \(error.localizedDescription)")
        }
    }
}
