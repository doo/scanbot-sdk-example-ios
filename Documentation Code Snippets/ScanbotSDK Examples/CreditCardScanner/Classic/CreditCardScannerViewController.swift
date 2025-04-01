//
//  CreditCardScannerViewController.swift
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 11.11.24.
//

import UIKit
import ScanbotSDK

class CreditCardScannerViewController: UIViewController {
    
    // The instance of the scanner view controller.
    private var scannerViewController: SBSDKCreditCardScannerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the default `SBSDKCreditCardScannerConfiguration` object.
        let configuration = SBSDKCreditCardScannerConfiguration()
        
        // Disable the requiring of expiration date.
        configuration.requireExpiryDate = false
        
        // Disable the requiring of the card holder name.
        configuration.requireCardholderName = false
        
        // Enable the credit card image extraction.
        configuration.returnCreditCardImage = true
        
        // Create the `SBSDKCreditCardScannerViewController` instance and embed it.
        self.scannerViewController = SBSDKCreditCardScannerViewController(parentViewController: self,
                                                                          parentView: self.view,
                                                                          configuration: configuration,
                                                                          delegate: self)
    }
}

extension CreditCardScannerViewController: SBSDKCreditCardScannerViewControllerDelegate {
    
    func creditCardScannerViewController(_ controller: SBSDKCreditCardScannerViewController,
                                         didScanCreditCard result: SBSDKCreditCardScanningResult) {
        
        // Access the document's fields directly by iterating over the document's fields.
        result.creditCard?.fields.forEach { field in
            // Print field type name, field text and field confidence to the console.
            print("\(field.type.name) = \(field.value?.text ?? "") (Confidence: \(field.value?.confidence ?? 0.0)")
        }
        
        // Get the cropped image.
        let croppedImage = result.creditCard?.crop?.toUIImage()
        
        // Or create a wrapper for the document if needed to access the fields more easily.
        // You must cast it to the specific document model wrapper subclass.
        if let wrapper = result.creditCard?.wrap() as? SBSDKCreditCardDocumentModelCreditCard {
            
            // Now you can access the document's fields easily through the wrapper.
            
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
