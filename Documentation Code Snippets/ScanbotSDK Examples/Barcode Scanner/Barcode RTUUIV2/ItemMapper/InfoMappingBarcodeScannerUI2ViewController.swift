//
//  InfoMappingBarcodeScannerUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 19.12.23.
//

import Foundation
import ScanbotSDK

class InfoMappingBarcodeScannerUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        Task {
            await self.startScanning()
        }
    }
    
    func startScanning() async {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2BarcodeScannerScreenConfiguration()
        
        // Create the default single scan use case object.
        let usecase = SBSDKUI2SingleScanningMode()
        
        // Enable the confirmation sheet.
        usecase.confirmationSheetEnabled = true
        
        // Set the item mapper.
        usecase.barcodeInfoMapping.barcodeItemMapper = self
        
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
        
        // Present the view controller modally.
        do {
            let result = try await SBSDKUI2BarcodeScannerViewController.present(on: self, configuration: configuration)
            
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
        
        } catch SBSDKError.operationCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } catch {
            // Any other error
            print("Error scanning barcode: \(error.localizedDescription)")
        }
    }
}

extension InfoMappingBarcodeScannerUI2ViewController: SBSDKUI2BarcodeItemMapper {
    
    func mapBarcodeItem(item: ScanbotSDK.SBSDKBarcodeItem,
                        onResult: @escaping (ScanbotSDK.SBSDKUI2BarcodeMappedData) -> Void,
                        onError: @escaping () -> Void) {
        
        // Handle the item .
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
