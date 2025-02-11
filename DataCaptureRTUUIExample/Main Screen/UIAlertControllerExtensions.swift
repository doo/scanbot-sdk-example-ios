//
//  UIAlertControllerExtensions.swift
//  DataCaptureRTUUIExample
//
//  Created by Sebastian Husche on 06.06.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

extension UIAlertController {

    class func showInfoAlert(_ title: String, message: String, presenter: UIViewController, completion: (() -> ())?) {
        let alert = SBSDKModalFormAlert.create(with: title, message: message, confirmButtonTitle: "Done") { 
            completion?()
        }
        presenter.present(alert, animated: true)
    }
}
