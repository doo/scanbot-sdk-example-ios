//
//  GenericTextLineRecognizerDemoViewController.swift
//  ClassicComponentsExample
//
//  Created by Danil Voitenko on 25.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class GenericTextLineRecognizerDemoViewController: UIViewController {
    @IBOutlet private var cameraContainer: UIView!
    @IBOutlet private var resultLabel: UILabel!
    
    private var textLineRecognizerController: SBSDKGenericTextLineScannerViewController?
    private var shouldRecognize: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let configuration = SBSDKGenericTextLineScannerConfiguration()
        
        var characterSet = CharacterSet.alphanumerics
        characterSet.formUnion(.whitespaces)
        characterSet.formUnion(.punctuationCharacters)
        
        
        let validator = SBSDKContentValidator.customContentValidator()
        
        validator.allowedCharacters = characterSet.toString()
        
        configuration.validator = validator
        
        textLineRecognizerController = SBSDKGenericTextLineScannerViewController(parentViewController: self,
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
    
    private func show(result: SBSDKGenericTextLineScannerResult) {
        resultLabel.textColor = result.validationSuccessful ? UIColor.green : UIColor.red
        resultLabel.text = result.rawText
    }
}

extension GenericTextLineRecognizerDemoViewController: SBSDKGenericTextLineScannerViewControllerDelegate {
    func textLineScannerViewControllerShouldRecognize(_ controller: SBSDKGenericTextLineScannerViewController) -> Bool {
        return shouldRecognize
    }
    
    func textLineScannerViewController(_ controller: SBSDKGenericTextLineScannerViewController,
                                       didValidate result: SBSDKGenericTextLineScannerResult) {
        DispatchQueue.main.async { [weak self] in
            self?.show(result: result)
        }
    }
}

extension CharacterSet {
    
    func toString() -> String {
        return String(self.characters)
    }
    
    var characters: [Character] {
        // A Unicode scalar is any Unicode code point in the range U+0000 to U+D7FF inclusive or U+E000 to U+10FFFF inclusive.
        return codePoints.compactMap { UnicodeScalar($0) }.map { Character($0) }
    }
    
    private var codePoints: [Int] {
        var result: [Int] = []
        var plane = 0
        // following documentation at https://developer.apple.com/documentation/foundation/nscharacterset/1417719-bitmaprepresentation
        for (i, w) in bitmapRepresentation.enumerated() {
            let k = i % 0x2001
            if k == 0x2000 {
                // plane index byte
                plane = Int(w) << 13
                continue
            }
            let base = (plane + k) << 3
            for j in 0 ..< 8 where w & 1 << j != 0 {
                result.append(base + j)
            }
        }
        return result
    }
}
