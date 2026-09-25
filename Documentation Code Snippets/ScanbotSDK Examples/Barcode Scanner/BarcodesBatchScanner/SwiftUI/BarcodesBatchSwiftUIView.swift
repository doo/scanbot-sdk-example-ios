//
//  BarcodesBatchSwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct BarcodesBatchSwiftUIView: View {

    // Property to indicate whether you want the scanner to detect barcodes or not.
    @State private var shouldDetectBarcodes = true
    
    @State private var model: SBSDKBarcodeScannerViewModel = {

        // The barcode formats to be scanned.
        let formatsToDetect = SBSDKBarcodeFormats.all
        
        // Create an instance of `SBSDKBarcodeFormatCommonConfiguration`, passing the desired barcode formats.
        let formatConfiguration = SBSDKBarcodeFormatCommonConfiguration(formats: formatsToDetect)
        
        // Create an instance of `SBSDKBarcodeScannerConfiguration`, passing the format configuration.
        let configuration = SBSDKBarcodeScannerConfiguration(barcodeFormatConfigurations: [formatConfiguration])
        
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

                // Set detection rate.
                model.configuration.userInterface.detectionRate = 5
                
                model.baseRuntime.isScanningEnabled = shouldDetectBarcodes
            }
            .onChange(of: shouldDetectBarcodes) { newValue in
                model.baseRuntime.isScanningEnabled = newValue
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
        
        for code in codes {
            // Get the source image.
            let sourceImage = try? code.sourceImage?.toUIImage()
        }
    }
}

#Preview {
    BarcodesBatchSwiftUIView()
}
