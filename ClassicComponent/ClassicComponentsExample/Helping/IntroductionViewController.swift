//
//  IntroductionViewController.swift
//  ClassicComponentsExample
//
//  Created by Rana Sohaib on 13.03.26.
//  Copyright © 2026 doo GmbH. All rights reserved.
//

import UIKit

class IntroductionViewController: UIViewController {
    
    private let infoText: String
    private let introTitle: String
    
    init(title: String = "Introduction", infoText: String) {
        self.introTitle = title
        self.infoText = infoText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupCloseButton()
        setupTextView()
    }
    
    private func setupCloseButton() {
        if let nav = navigationController {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close",
                                                                style: .done,
                                                                target: self,
                                                                action: #selector(dismissSelf))
            title = introTitle
        } else {
            let closeButton = UIButton(type: .system)
            closeButton.setTitle("Close", for: .normal)
            closeButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(closeButton)
            
            NSLayoutConstraint.activate([
                closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
            ])
        }
    }
    
    private func setupTextView() {
        let textView = UITextView()
        textView.text = infoText
        textView.isEditable = false
        textView.isSelectable = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textColor = .label
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textView)
        
        let topAnchor: NSLayoutYAxisAnchor = view.safeAreaLayoutGuide.topAnchor
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true)
    }
}
