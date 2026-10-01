//
//  BarcodesOverlaySwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct BarcodesOverlaySwiftUIView: View {
    
    @State private var model: SBSDKBarcodeScannerViewModel = {
        
        // The barcode formats to be detected.
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
                
                // Enable the barcodes tracking overlay.
                model.trackingOverlay.isTrackingOverlayEnabled = true
                
                // Get current tracking configuration object.
                let trackingConfiguration = model.trackingOverlay.trackingOverlayConfiguration
                
                // Set the color for the polygons of the tracked barcodes.
                trackingConfiguration.defaultStyle.polygonColor = UIColor(red: 0, green: 0.81, blue: 0.65, alpha: 0.8)
                
                // Set the text color of the tracked barcodes.
                trackingConfiguration.defaultStyle.textColor = UIColor.black
                
                // Set the text background color of the tracked barcodes.
                trackingConfiguration.defaultStyle.textBackgroundColor = UIColor(red:0, green:0.81, blue:0.65, alpha:0.8)
                
                // Set the text format of the tracked barcodes.
                trackingConfiguration.defaultStyle.textFormat = .codeAndType
                
                // Set the style used for selected tracked barcodes.
                let selectionStyle = trackingConfiguration.defaultStyle.copy() as! SBSDKBarcodeTrackingOverlayStyle
                selectionStyle.polygonColor = UIColor(red:0.784, green:0.1, blue:0.235, alpha:0.8)
                selectionStyle.textColor = UIColor.white
                selectionStyle.textBackgroundColor = UIColor(red:0.784, green:0.1, blue:0.235, alpha:0.8)
                trackingConfiguration.selectionStyle = selectionStyle
                
                // Re-assign to commit the changes and force the overlay to redraw already-tracked items.
                model.trackingOverlay.trackingOverlayConfiguration = trackingConfiguration
                model.trackingOverlay.handlers = SBSDKBarcodeTrackingOverlayHandlers(style: { item, proposedStyle in
                    guard item.barcode.format == SBSDKBarcodeFormat.qrCode else { return proposedStyle }
                    let style = proposedStyle.copy() as! SBSDKBarcodeTrackingOverlayStyle
                    style.polygonColor = UIColor.red
                    style.polygonBackgroundColor = UIColor.purple.withAlphaComponent(0.2)
                    style.textBackgroundColor = UIColor.purple.withAlphaComponent(0.2)
                    return style
                }, didTap: { barcode in
                    // Process the barcode selected by the user.
                    print(barcode)
                    
                    // Get the source image.
                    let sourceImage = try? barcode.sourceImage?.toUIImage()
                })
            }
    }
}

#Preview {
    BarcodesOverlaySwiftUIView()
}
