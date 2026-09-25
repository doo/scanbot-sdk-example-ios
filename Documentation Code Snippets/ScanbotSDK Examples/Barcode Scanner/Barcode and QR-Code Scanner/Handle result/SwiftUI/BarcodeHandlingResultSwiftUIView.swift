//
//  BarcodeHandlingResultSwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct BarcodeHandlingResultSwiftUIView: View {
    
    @State private var model: SBSDKBarcodeScannerViewModel = {
        return try! SBSDKBarcodeScannerViewModel(scannerConfiguration: .init())
    }()
    
    var body: some View {
        SBSDKScannerView(model: model)
            .onReceive(model.frameEngine.events) { event in
                switch event {
                case .validResult(let snapshot, _):
                    handle(codes: snapshot.barcodes)

                case .everyFrame:
                    break

                case .failure(let error):
                    // Handle the error.
                    print("Error scanning barcode: \(error.localizedDescription)")
                }
            }
    }
    
    func handle(codes: [SBSDKBarcodeItem]) {
        
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

#Preview {
    BarcodeHandlingResultSwiftUIView()
}
