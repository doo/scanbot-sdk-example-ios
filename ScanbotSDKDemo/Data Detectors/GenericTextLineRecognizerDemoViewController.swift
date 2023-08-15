//
//  GenericTextLineRecognizerDemoViewController.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 25.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class GenericTextLineRecognizerDemoViewController: UIViewController {
    @IBOutlet private var cameraContainer: UIView!
    @IBOutlet private var resultLabel: UILabel!
    
    private var textLineRecognizerController: SBSDKGenericTextLineRecognizerViewController?
    private var shouldRecognize: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = SBSDKGenericTextLineRecognizerConfiguration.default()
        
        var characterSet = CharacterSet.alphanumerics
        characterSet.formUnion(.whitespaces)
        characterSet.formUnion(.punctuationCharacters)
        characterSet.invert()
        
        let sanitizerBlock: SBSDKTextLineRecognizerTextSanitizerBlock = { rawText in
            let components = rawText.components(separatedBy: characterSet).filter({ !$0.isEmpty })
            return components.joined(separator: "")
        }
        configuration.stringSanitizerBlock = sanitizerBlock
        
        textLineRecognizerController = SBSDKGenericTextLineRecognizerViewController(parentViewController: self,
                                                                                    parentView: cameraContainer,
                                                                                    configuration: configuration,
                                                                                    delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        shouldRecognize = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        shouldRecognize = false
    }
    
    private func show(result: SBSDKGenericTextLineRecognizerResult) {
        resultLabel.textColor = result.validationSuccessful ? UIColor.green : UIColor.red
        resultLabel.text = result.text
    }
}

extension GenericTextLineRecognizerDemoViewController: SBSDKGenericTextLineRecognizerViewControllerDelegate {
    func textLineRecognizerViewControllerShouldRecognize(_ controller: SBSDKGenericTextLineRecognizerViewController) -> Bool {
        return shouldRecognize
    }
    
    func textLineRecognizerViewController(_ controller: SBSDKGenericTextLineRecognizerViewController,
                                          didValidate result: SBSDKGenericTextLineRecognizerResult) {
        DispatchQueue.main.async { [weak self] in
            self?.show(result: result)
        }
    }
}
