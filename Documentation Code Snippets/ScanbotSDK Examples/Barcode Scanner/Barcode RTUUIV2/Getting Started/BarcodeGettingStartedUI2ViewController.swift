//
//  BarcodeGettingStartedUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 15.07.25.
//

import Foundation
import ScanbotSDK

class BarcodeGettingStartedUI2ViewController: UIViewController {
    
    func launchRTUUIv2Scanner() {
        
        Task {
            // Create the default configuration object.
            let configuration = SBSDKUI2BarcodeScannerScreenConfiguration()
            
            // Present the view controller modally.
            do {
                let result = try await SBSDKUI2BarcodeScannerViewController.present(on: self,
                                                                                    configuration: configuration)
                // Process the result as needed.
                
            } catch SBSDKError.operationCanceled {
                print("The operation was cancelled before completion or by the user")
                
            } catch {
                // Any other error
                print("Error scanning barcode: \(error.localizedDescription)")
            }
        }
    }
    
    func handleScanResults() {
        
        Task {
            // Create the default configuration object.
            let configuration = SBSDKUI2BarcodeScannerScreenConfiguration()
            
            // Present the view controller modally.
            do {
                let result = try await SBSDKUI2BarcodeScannerViewController.present(on: self,
                                                                                    configuration: configuration)
                // Process result
                result.items.forEach({ item in
                    
                    print("Barcode Identity String: \(item.barcode.identityString)")
                    print("Scan count: \(item.count)")
                    print("Barcode Text: \(item.barcode.text)")
                    print("Barcode Text with Extension: \(item.barcode.textWithExtension)")
                    print("Barcode Format: \(item.barcode.format)")
                    
                    // Retrieve the extracted (known) document.
                    // e.g Boarding Pass
                    if let boardingPass = SBSDKBarcodeDocumentModelBoardingPass(document: item.barcode.extractedDocument) {
                        
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
            catch SBSDKError.operationCanceled {
                print("The operation was cancelled before completion or by the user")
                
            } catch {
                // Any other error
                print("Error scanning barcode: \(error.localizedDescription)")
            }
        }
    }
}
