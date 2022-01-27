//
//  Usecase.swift
//  ReadyToUseUIDemo
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
        self.didStart()
    }
    
    func presentViewController(_ viewController: UIViewController) {
        viewController.modalPresentationStyle = .overFullScreen
        self.presenter?.present(viewController, animated: true, completion: nil)
    }
    
    func didStart() {
        if Thread.current != Thread.main {
            fatalError("Usescases must be called on main thread.")
        }
        Usecase.activeUsecases[self.id] = self
    }
    
    func didFinish() {
        if Thread.current != Thread.main {
            fatalError("Usescases must be called on main thread.")
        }
        self.presenter = nil
        Usecase.activeUsecases.removeValue(forKey: self.id)
    }
}
