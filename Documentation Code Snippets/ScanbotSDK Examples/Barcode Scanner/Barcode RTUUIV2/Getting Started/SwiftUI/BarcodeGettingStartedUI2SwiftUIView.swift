//
//  BarcodeGettingStartedUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct BarcodeGettingStartedUI2SwiftUIView: View {
    
    @State private var configuration: SBSDKUI2BarcodeScannerScreenConfiguration?
    @State private var scanError: Error?
    @State private var scannerResult: SBSDKUI2BarcodeScannerUIResult?
    @State private var errorMessage: String?
    
    var body: some View {
        
        if let configuration {
            
            // Create and present the scanner view.
            SBSDKUI2BarcodeScannerView(configuration: configuration,
                                                                 completion: { result, error in
                scannerResult = result
                scanError = error
                self.configuration = nil
                if let result {
                    handle(result: result)
                }
                if let error {
                    if case SBSDKError.operationCanceled = error {
                        print("The operation was cancelled before completion or by the user")
                    } else {
                        // Any other error
                        print("Error scanning barcode: \(error.localizedDescription)")
                    }
                }
            })
                    .ignoresSafeArea()

            
        } else if let scannerResult {
            Text("Barcodes scanned: \(scannerResult.items.count)")

        } else if let scanError {
            Text("Scan error: \(scanError.localizedDescription)")

        } else if let errorMessage {
            Text(errorMessage)

        } else {
            Button("Start scanning") {
                launchRTUUIv2Scanner()
            }
        }
    }
    
    func launchRTUUIv2Scanner() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2BarcodeScannerScreenConfiguration()
        
        self.configuration = configuration
    }
    
    func launchRTUUIv2Scanner(json: String) {
        do {
            let report = try SBSDKJSONValidator.validate(
                json: json,
                configurationClass: SBSDKUI2BarcodeScannerScreenConfiguration.self)
            guard report.isValid else {
                var message = report.issues.map { "\($0.path): \($0.message)" }
                    .joined(separator: "\n")
                if !report.isComplete {
                    message += "\nFix the decoding error and validate again to check unknown fields."
                }
                errorMessage = message
                return
            }
            let configuration = try JSONDecoder().decode(
                SBSDKUI2BarcodeScannerScreenConfiguration.self, from: Data(json.utf8))
            self.configuration = configuration
        } catch SBSDKError.operationCanceled {
            return
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func handleScanResults() {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2BarcodeScannerScreenConfiguration()
        
        self.configuration = configuration
    }
    
    func handle(result: SBSDKUI2BarcodeScannerUIResult) {
        
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
}

#Preview {
    BarcodeGettingStartedUI2SwiftUIView()
}
