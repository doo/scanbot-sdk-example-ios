//
//  TextViewController.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 25.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {
    @IBOutlet private var textView: UITextView?
    var textToDisplay: String? {
        didSet {
            updateText()
        }
    }
    
    static func make(with text: String) -> TextViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "TextViewController") as!
        TextViewController
        controller.textToDisplay = text
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
        
    private func updateText() {
        if isViewLoaded {
            textView?.text = textToDisplay
        }
    }
}
