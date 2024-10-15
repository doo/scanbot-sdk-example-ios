//
//  AlertsManager.swift
//  ClassicComponentsExample
//
//  Created by Danil Voitenko on 25.01.22.
//  Copyright © 2022 doo GmbH. All rights reserved.
//

import UIKit

final class AlertsManager {
    
    let presenter: UIViewController
    
    init(presenter: UIViewController) {
        self.presenter = presenter
    }
    
    func showSuccessAlert(with results: String?, completionHandler:(() -> ())? = nil) {
        let alert = UIAlertController(title: "Detected results", message: results, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completionHandler?()
        }
        
        let copy = UIAlertAction(title: "Copy to clipboard", style: .default) { _ in
            UIPasteboard.general.string = results
            let copiedAlert = UIAlertController(title: "Copied", message: nil, preferredStyle: .alert)
            self.presenter.present(copiedAlert, animated: true) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    copiedAlert.presentingViewController?.dismiss(animated: true, completion: nil)
                    completionHandler?()
                }
            }
        }
        alert.addAction(copy)
        alert.addAction(cancel)
        presenter.present(alert, animated: true, completion: nil)
    }
    
    func showFailureAlert(completionHandler:(() -> ())? = nil) {
        let alert = UIAlertController(title: "Nothing detected", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            if let presenter = alert.presentingViewController {
                presenter.dismiss(animated: true, completion: nil)
            }
            completionHandler?()
        }
        alert.addAction(cancel)
        presenter.present(alert, animated: true, completion: nil)
    }
}
