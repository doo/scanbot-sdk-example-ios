//
//  BarcodeDataParserSwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct BarcodeDataParserSwiftUIView: View {

    @State private var model: SBSDKBarcodeScannerViewModel = {
        
        // The barcode document formats to be scanned.
        let documentFormatsToDetect = [SBSDKBarcodeDocumentFormat.swissQr]
        
        // Get the supported barcode formats for the document formats set above.
        let barcodeFormats = SBSDKBarcodeDocumentFormat.supportedBarcodeFormats(for: documentFormatsToDetect)
        
        // Create an instance of `SBSDKBarcodeFormatCommonConfiguration`.
        let formatConfiguration = SBSDKBarcodeFormatCommonConfiguration(formats: barcodeFormats)
        
        // Create an instance of `SBSDKBarcodeScannerConfiguration`.
        let configuration = SBSDKBarcodeScannerConfiguration(barcodeFormatConfigurations: [formatConfiguration],
                                                             extractedDocumentFormats: documentFormatsToDetect)
        
        // Enable the barcode image extraction.
        configuration.returnBarcodeImage = true
        
        return try! SBSDKBarcodeScannerViewModel(scannerConfiguration: configuration)
    }()
    
    var body: some View {
        SBSDKScannerView(model: model)
            .onAppear {
                // Enable the view finder.
                model.configuration.viewFinder.isViewFinderEnabled = true
                
                // Set the finder's aspect ratio.
                model.configuration.viewFinder.aspectRatio = SBSDKAspectRatio(width: 2, height: 1)
                
                // Set the finder's minimum insets.
                model.configuration.viewFinder.minimumInset = UIEdgeInsets(top: 100, left: 50, bottom: 100, right: 50)
                
                // Configure the view finder colors and line properties.
                model.configuration.viewFinder.lineColor = UIColor.red
                model.configuration.viewFinder.backgroundColor = UIColor.red.withAlphaComponent(0.1)
                model.configuration.viewFinder.lineWidth = 2
                model.configuration.viewFinder.lineCornerRadius = 8
                

                // Set the detection rate.
                model.configuration.userInterface.detectionRate = 5
            }
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
        
        // Process the detected barcodes.
        let barcode = codes.first
        
        // Get the source image.
        let sourceImage = try? barcode?.sourceImage?.toUIImage()
        
        // Run the parser and check the result.
        if let document = SBSDKBarcodeDocumentModelSwissQR(document: barcode?.extractedDocument) {
            
            // Enumerate the Swiss QR code data fields.
            for field in document.document.fields {
                
                // Do something with the fields.
                print("\(field.type.fullName) = \(field.value?.text)")
            }
        }
    }
}

#Preview {
    BarcodeDataParserSwiftUIView()
}
