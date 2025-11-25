//
//  DocumentIntroductionUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 05.08.24.
//

import Foundation
import ScanbotSDK

class DocumentIntroductionUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        Task {
            await self.startScanning()
        }
    }
    
    func startScanning() async {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2DocumentScanningFlow()
        
        // Retrieve the instance of the introduction configuration from the main configuration object.
        let introductionConfiguration = configuration.screens.camera.introduction
        
        // Show the introduction screen automatically when the screen appears.
        introductionConfiguration.showAutomatically = true
        
        // Create a new introduction item.
        let firstExampleEntry = SBSDKUI2IntroListEntry()
        
        // Configure the introduction image to be shown.
        firstExampleEntry.image = .receiptsIntroImage()
        
        // Configure the text.
        firstExampleEntry.text = SBSDKUI2StyledText(text: "Some text explaining how to scan a receipt",
                                                    color: SBSDKUI2Color(colorString: "#000000"))
        
        // Create a second introduction item.
        let secondExampleEntry = SBSDKUI2IntroListEntry()
        
        // Configure the introduction image to be shown.
        secondExampleEntry.image = .checkIntroImage()
        
        // Configure the text.
        secondExampleEntry.text = SBSDKUI2StyledText(text: "Some text explaining how to scan a check",
                                                     color: SBSDKUI2Color(colorString: "#000000"))
        
        // Set the items into the configuration.
        introductionConfiguration.items = [firstExampleEntry, secondExampleEntry]
        
        // Set the screen title.
        introductionConfiguration.title = SBSDKUI2StyledText(text: "Introduction",
                                                             color: SBSDKUI2Color(colorString: "#000000"))
        
        // Apply the introduction configuration.
        configuration.screens.camera.introduction = introductionConfiguration
        
        // Present the view controller modally.
        do {
            let result = try await SBSDKUI2DocumentScannerController.present(on: self, configuration: configuration)
            
            // Handle the result.
            print(result.uuid)
            print(result.pageCount)
            print(result.documentImageSizeLimit)
            print(result.pdfURI)
            print(result.tiffURI)
            print(result.creationDate)
            
            // Check out other available properties in `SBSDKScannedDocument`.
            
            result.pages.forEach { scannedPage in
                
                print(scannedPage.uuid)
                print(scannedPage.documentDetectionStatus)
                print(scannedPage.polygon)
                print(scannedPage.source)
                
                let originalImage = scannedPage.originalImage
                let originalImageURI = scannedPage.originalImageURI
                
                let documentImage = scannedPage.documentImage
                let documentImageURI = scannedPage.documentImageURI
                
                let documentImagePreview = scannedPage.documentImagePreview
                let documentImagePreviewURI = scannedPage.documentImagePreviewURI
                
                if let documentQuality = scannedPage.documentQuality {
                    switch documentQuality {
                    case .veryPoor: print("veryPoor")
                    case .poor: print("poor")
                    case .reasonable: print("reasonable")
                    case .good: print("good")
                    case .excellent: print("excellent")
                    default: print("unknown")
                    }
                }
                // Check out other available properties in `SBSDKScannedPage`
            }
        
        } catch SBSDKError.operationCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } catch {
            // Any other error
            print("Error scanning document: \(error.localizedDescription)")
        }
    }
}
