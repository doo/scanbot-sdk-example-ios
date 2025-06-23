//
//  SBSDKModalFormAlert.swift
//  DataCaptureRTUUIExample
//
//  Created by Seifeddine Bouzid on 25.10.24.
//  Copyright © 2024 doo GmbH. All rights reserved.
//

import UIKit

class SBSDKModalFormAlert: UIViewController {
    
    @IBOutlet private var handleView: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var messageContainer: UITextView!
    @IBOutlet private var separatorView: UIView!
    @IBOutlet private var doneButton: UIButton!
    
    private var message: String?
    private var alertTitle: String?
    private var confirmButtonTitle: String?
    private var handler: (() -> ())? = nil
    
    static func create(with title: String?,
                       message: String?,
                       confirmButtonTitle: String,
                       didPressConfirmButton handler: (() -> ())?) -> SBSDKModalFormAlert {
        
        let storyboard = UIStoryboard(name: "DefaultUIDialogs", bundle: Bundle(for: SBSDKModalFormAlert.self))
        let alert: SBSDKModalFormAlert = storyboard.instantiateViewController(identifier: "SBSDKModalFormAlert")
        
        alert.alertTitle = title
        alert.message = message
        alert.handler = handler
        alert.confirmButtonTitle = confirmButtonTitle
        return alert
    }
    
    override var modalPresentationStyle: UIModalPresentationStyle {
        get { return .pageSheet }
        set { super.modalPresentationStyle = .pageSheet }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyConfig()
    }
    
    private func applyConfig() {
        titleLabel.text = alertTitle
        messageContainer.text = message
        doneButton.setTitle(confirmButtonTitle, for: .normal)
        
        handleView.layer.cornerRadius = 2.5
    }
    
    @IBAction private func doneButtonDidTap(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: { 
            self.handler?()
        })
    }
}
