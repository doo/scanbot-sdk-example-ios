//
//  Usecase.swift
//  DataCaptureRTUUIExample
//
//  Created by Sebastian Husche on 02.07.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import UIKit

class Usecase: NSObject {
    
    private static var activeUsecases = [String: Usecase]()
    
    private let id = UUID().uuidString
    
    var presenter: UIViewController?
    
    func start(presenter: UIViewController) {
        if Thread.current != Thread.main {
            fatalError("Usescases must be called on main thread.")
        }
        self.presenter = presenter
        didStart()
    }
    
    func presentViewController(_ viewController: UIViewController) {
        viewController.modalPresentationStyle = .fullScreen
        presenter?.present(viewController, animated: true, completion: nil)
    }
    
    func didStart() {
        if Thread.current != Thread.main {
            fatalError("Usescases must be called on main thread.")
        }
        Usecase.activeUsecases[self.id] = self
    }
    
    func handleError(_ error: Error) {
        presenter?.sbsdk_showError(error)
    }
    
    func didFinish(error: Error?) {
        if Thread.current != Thread.main {
            fatalError("Usescases must be called on main thread.")
        }
        if let error {
            handleError(error)
        }
        presenter = nil
        Usecase.activeUsecases.removeValue(forKey: self.id)
    }
}
