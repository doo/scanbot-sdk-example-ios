//
//  CreditCardRecognizerViewController.swift
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 11.11.24.
//

import UIKit
import ScanbotSDK

class CreditCardRecognizerViewController: UIViewController {
    
    // The instance of the recognizer view controller.
    private var recognizerViewController: SBSDKCreditCardRecognizerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the default SBSDKCreditCardRecognizerConfiguration object.
        let configuration = SBSDKCreditCardRecognizerConfiguration()
        
        // Disable the validation of expiration date.
        configuration.requireExpiryDate = false
        
        // Disable the validation of the card holder name.
        configuration.requireCardholderName = false
        
        // Create the `SBSDKCreditCardRecognizerViewController` instance and embed it.
        self.recognizerViewController = SBSDKCreditCardRecognizerViewController(parentViewController: self,
                                                                                parentView: self.view,
                                                                                configuration: configuration,
                                                                                delegate: self)
    }
}

extension CreditCardRecognizerViewController: SBSDKCreditCardRecognizerViewControllerDelegate {
    
    func creditCardRecognizerViewController(_ controller: SBSDKCreditCardRecognizerViewController,
                                            didRecognizeCreditCard result: SBSDKCreditCardRecognitionResult) {
        
        // Access the documents fields directly by iterating over the documents fields.
        result.creditCard?.fields.forEach { field in
            // Print field type name, field text and field confidence to the console.
            print("\(field.type.name) = \(field.value?.text ?? "") (Confidence: \(field.value?.confidence ?? 0.0)")
        }
        
        // Or create a wrapper for the document if needed to access the fields more easily.
        // You must cast it to the specific document model wrapper subclass.
        if let wrapper = result.creditCard?.wrap() as? SBSDKCreditCardDocumentModelCreditCard {
    
            // Now you can access the documents fields easily through the wrapper.
            
            if let creditCardNumber = wrapper.cardNumber {
                print("Credit card number: \(creditCardNumber.value?.text ?? "")")
            }
            
            if let cardHolderName = wrapper.cardholderName {
                print("Cardholder name: \(cardHolderName.value?.text ?? "")")
            }
            
            if let expiryDate = wrapper.expiryDate {
                print("Expiration date: \(expiryDate.value?.text ?? "")")
            }
        }
    }
}
