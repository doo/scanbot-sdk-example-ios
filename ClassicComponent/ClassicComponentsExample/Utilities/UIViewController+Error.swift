//
//  UIViewController+Error.swift
//  ClassicComponentsExample
//
//  Created by Sebastian Husche on 18.11.25.
//  Copyright © 2025 doo GmbH. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func handleError(_ error: Error) {
        guard self.presentedViewController == nil else { return }
        
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .default,
                                      handler: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
}
