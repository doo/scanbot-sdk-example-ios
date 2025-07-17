//
//  BarcodeHandlingResultViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 15.07.25.
//

import Foundation
import ScanbotSDK

class BarcodeHandlingResultViewController: UIViewController {
    
    // The instance of the scanner view controller.
    var scannerViewController: SBSDKBarcodeScannerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the `SBSDKBarcodeScannerViewController` instance.
        self.scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                       parentView: self.view,
                                                                       configuration: .init(),
                                                                       delegate: self)
    }
}

extension BarcodeHandlingResultViewController: SBSDKBarcodeScannerViewControllerDelegate {
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  didScanBarcodes codes: [SBSDKBarcodeItem]) {
        
        // Process result
        codes.forEach({ barcode in
            
            print("Barcode Identity String: \(barcode.identityString)")
            print("Barcode Text: \(barcode.text)")
            print("Barcode Text with Extension: \(barcode.textWithExtension)")
            print("Barcode Format: \(barcode.format)")
            
            // Retrieve the extracted (known) document.
            // e.g Boarding Pass
            if let boardingPass = SBSDKBarcodeDocumentModelBoardingPass(document: barcode.extractedDocument) {
                
                if let passengerName = boardingPass.passengerName {
                    print("Passenger name: \(passengerName)")
                }
                print("Number of legs: \(boardingPass.legs)")
                
                boardingPass.legs.forEach({ (leg) in
                    print("Flight number: \(leg.flightNumber?.value?.text ?? "")")
                    print("Seat number: \(leg.seatNumber?.value?.text ?? "")")
                    print("Date of flight julian: \(leg.dateOfFlightJulian?.value?.text ?? "")")
                    print("Departure Airport code: \(leg.departureAirportCode?.value?.text ?? "")")
                    print("Destination Airport code: \(leg.destinationAirportCode?.value?.text ?? "")")
                    
                    // or print all fields.
                    leg.document.fields.forEach({ field in
                        print("\n" + "\(field.type.displayText ?? ""): \(field.value?.text ?? "")")
                    })
                })
                
                // or print all fields.
                boardingPass.document.fields.forEach({ field in
                    print("\n" + "\(field.type.displayText ?? ""): \(field.value?.text ?? "")")
                })
            }
            
        })
    }
}
