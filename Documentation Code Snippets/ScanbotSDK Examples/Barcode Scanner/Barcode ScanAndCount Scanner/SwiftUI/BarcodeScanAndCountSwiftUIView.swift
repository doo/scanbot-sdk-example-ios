//
//  BarcodeScanAndCountSwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct BarcodeScanAndCountSwiftUIView: View {
    
    @State private var model: SBSDKBarcodeScanAndCountViewModel = {
        
        // The barcode formats to be detected.
        let formatsToDetect = SBSDKBarcodeFormats.all
        
        // Create an instance of `SBSDKBarcodeFormatCommonConfiguration`.
        let formatConfiguration = SBSDKBarcodeFormatCommonConfiguration(formats: formatsToDetect)
        
        // Create an instance of `SBSDKBarcodeScannerConfiguration`.
        let configuration = SBSDKBarcodeScannerConfiguration(barcodeFormatConfigurations: [formatConfiguration])
        
        // Enable the barcode image extraction.
        configuration.returnBarcodeImage = true
        
        return try! SBSDKBarcodeScanAndCountViewModel(scannerConfiguration: configuration)
    }()
    
    var body: some View {
        SBSDKScannerView(model: model)
            .onAppear {
                
                // Create a new instance of the polygon style.
                let polygonStyle = SBSDKScanAndCountPolygonStyle()
                
                // Enable the barcode polygon overlay.
                polygonStyle.polygonDrawingEnabled = true
                
                // Set the color for the results overlay polygons.
                polygonStyle.polygonColor = UIColor(red: 0, green: 0.81, blue: 0.65, alpha: 0.8)
                
                // Set the color for the polygon's fill.
                polygonStyle.polygonFillColor = UIColor(red: 0, green: 0.81, blue: 0.65, alpha: 0.2)
                
                // Set the line width for the polygon.
                polygonStyle.lineWidth = 2
                
                // Set the corner radius for the polygon.
                polygonStyle.cornerRadius = 8
                
                // Set the polygon style to apply it.
                model.configuration.polygonStyle = polygonStyle
                
                // Set the capture mode of the scanner.
                model.configuration.captureMode = .capturedImage
            }
            .onReceive(model.frameEngine.events) { event in
                switch event {
                case .capturedResult(let result, _):
                    handle(codes: result.barcodes)

                case .everyFrame, .validResult:
                    break

                case .failure(let error):
                    // Handle the error.
                    print("Error scanning barcode: \(error.localizedDescription)")
                }
            }
    }
    
    func handle(codes: [SBSDKBarcodeItem]) {
        // Process the detected barcodes.
        print(codes)
        
        for code in codes {
            // Get the source image.
            let sourceImage = try? code.sourceImage?.toUIImage()
        }
    }
}

#Preview {
    BarcodeScanAndCountSwiftUIView()
}
