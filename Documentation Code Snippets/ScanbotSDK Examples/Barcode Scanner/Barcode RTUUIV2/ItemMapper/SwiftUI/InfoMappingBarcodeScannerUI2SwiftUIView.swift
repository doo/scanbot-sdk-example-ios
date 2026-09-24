//
//  InfoMappingBarcodeScannerUI2SwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct InfoMappingBarcodeScannerUI2SwiftUIView: View {
    
    private let barcodeItemMapper: InfoMappingBarcodeScannerUI2SwiftUIItemMapper
    @State private var configuration: SBSDKUI2BarcodeScannerScreenConfiguration
    @State private var scanError: Error?
    @State private var scannerResult: SBSDKUI2BarcodeScannerUIResult?
    
    init() {
        let barcodeItemMapper = InfoMappingBarcodeScannerUI2SwiftUIItemMapper()
        self.barcodeItemMapper = barcodeItemMapper
        _configuration = State(initialValue: Self.makeConfiguration(barcodeItemMapper: barcodeItemMapper))
    }
    
    var body: some View {
        
        if let scannerResult {
            Text("Barcodes scanned: \(scannerResult.items.count)")

        } else if let scanError {
            Text("Scan error: \(scanError.localizedDescription)")

        } else {
            
            // Create and present the scanner view.
            SBSDKUI2BarcodeScannerView(configuration: configuration,
                                                                 completion: { result, error in
                scannerResult = result
                scanError = error
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

        }
    }
    
    static func makeConfiguration(barcodeItemMapper: InfoMappingBarcodeScannerUI2SwiftUIItemMapper) -> SBSDKUI2BarcodeScannerScreenConfiguration {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2BarcodeScannerScreenConfiguration()
        
        // Create the default single scan use case object.
        let usecase = SBSDKUI2SingleScanningMode()
        
        // Enable the confirmation sheet.
        usecase.confirmationSheetEnabled = true
        
        // Set the item mapper.
        usecase.barcodeInfoMapping.barcodeItemMapper = barcodeItemMapper
        
        // Retrieve the instance of the error state from the use case object.
        let errorState = usecase.barcodeInfoMapping.errorState
        
        // Configure the title.
        errorState.title.text = "Error_Title"
        errorState.title.color = SBSDKUI2Color(colorString: "#000000")
        
        // Configure the subtitle.
        errorState.subtitle.text = "Error_Subtitle"
        errorState.subtitle.color = SBSDKUI2Color(colorString: "#000000")
        
        // Configure the cancel button.
        errorState.cancelButton.text = "Cancel"
        errorState.cancelButton.foreground.color = SBSDKUI2Color(colorString: "#C8193C")
        
        // Configure the retry button.
        errorState.retryButton.text = "Retry"
        errorState.retryButton.foreground.iconVisible = true
        errorState.retryButton.foreground.color = SBSDKUI2Color(colorString: "#FFFFFF")
        errorState.retryButton.background.fillColor = SBSDKUI2Color(colorString: "#C8193C")
        
        // Set the configured error state.
        usecase.barcodeInfoMapping.errorState = errorState
        
        // Set the configured use case.
        configuration.useCase = usecase
        
        // Create and set an array of accepted barcode formats.
        configuration.scannerConfiguration.setBarcodeFormats(SBSDKBarcodeFormats.twod)
        
        return configuration
    }
    
    func handle(result: SBSDKUI2BarcodeScannerUIResult) {
        
        // Handle the result.
        result.items.forEach { barcodeItem in
            // e.g
            print(barcodeItem.count)
            print(barcodeItem.barcode.format.name)
            print(barcodeItem.barcode.text)
            print(barcodeItem.barcode.textWithExtension)
            // Check out other available properties in `SBSDKBarcodeItem`.
        }
        print(result.selectedZoomFactor)
    }
}

class InfoMappingBarcodeScannerUI2SwiftUIItemMapper: SBSDKUI2BarcodeItemMapper {
    
    func mapBarcodeItem(item: ScanbotSDK.SBSDKBarcodeItem,
                        onResult: @escaping (ScanbotSDK.SBSDKUI2BarcodeMappedData) -> Void,
                        onError: @escaping () -> Void) {
        
        // Handle the item.
        // E.g. fetching the product info.
        
        let fetchedSuccessfully = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            if fetchedSuccessfully {
                
                // Show Mapped data.
                
                let fetchedTitle = "Title"
                let fetchedSubtitle = "Subtitle"
                let fetchedImageUrl = "Image_URL"
                
                // You can also pass the `SBSDKUI2BarcodeMappedData.barcodeImageKey` instead of the fetched image
                // to display the original barcode image.
                
                // Create an instance of a mapped data.
                let mappedData = SBSDKUI2BarcodeMappedData(title: fetchedTitle,
                                                           subtitle: fetchedSubtitle,
                                                           barcodeImage: fetchedImageUrl)
                
                // Pass the mapped data object in an `onResult` completion handler.
                onResult(mappedData)
                
            } else {
                
                // Call the onError completion handler.
                onError()
            }
        }
    }
}

#Preview {
    InfoMappingBarcodeScannerUI2SwiftUIView()
}
