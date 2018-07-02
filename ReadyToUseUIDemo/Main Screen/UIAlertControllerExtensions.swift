//
//  UIAlertControllerExtensions.swift
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 06.06.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import UIKit

extension UIAlertController {

    class func showInfoAlert(_ title: String, message: String, presenter: UIViewController, completion: (() -> ())?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default) { (_) in
            completion?()
        }
        alert.addAction(action)
        presenter.present(alert, animated: true, completion: nil)
    }
}
