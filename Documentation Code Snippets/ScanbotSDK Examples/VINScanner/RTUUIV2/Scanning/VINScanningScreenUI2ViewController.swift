//
//  VINScanningScreenUI2ViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 05.02.25.
//

import UIKit
import ScanbotSDK

class VINScanningScreenUI2ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning here. Usually this is an action triggered by some button or menu.
        Task {
            await startScanning()
        }
    }
    
    func startScanning() async {
        
        // Create the default configuration object.
        let configuration = SBSDKUI2VINScannerScreenConfiguration()
        
        // Configure camera properties.
        // e.g
        configuration.cameraConfiguration.zoomSteps = [1.0, 2.0, 5.0]
        configuration.cameraConfiguration.flashEnabled = false
        configuration.cameraConfiguration.pinchToZoomEnabled = true
        
        // Configure the UI elements like icons or buttons.
        // e.g The top bar introduction button.
        configuration.topBarOpenIntroScreenButton.visible = true
        configuration.topBarOpenIntroScreenButton.color = SBSDKUI2Color(colorString: "#FFFFFF")
        // Cancel button.
        configuration.topBar.cancelButton.visible = true
        configuration.topBar.cancelButton.text = "Cancel"
        configuration.topBar.cancelButton.foreground.color = SBSDKUI2Color(colorString: "#FFFFFF")
        configuration.topBar.cancelButton.background.fillColor = SBSDKUI2Color(colorString: "#00000000")
        
        // Configure the view finder.
        // Set the desired aspect ratio.
        configuration.viewFinder.aspectRatio = SBSDKAspectRatio(width: 3.85, height: 1.0)
        // Set the style for the view finder.
        // Choose between cornered or stroked style.
        // For default stroked style.
        configuration.viewFinder.style = .finderStrokedStyle()
        // For default cornered style.
        configuration.viewFinder.style = .finderCorneredStyle()
        // You can also set each style's stroke width, stroke color or corner radius.
        // e.g
        configuration.viewFinder.style = SBSDKUI2FinderCorneredStyle(strokeWidth: 2.0)
        
        // Configure the success overlay.
        configuration.successOverlay.iconColor = SBSDKUI2Color(colorString: "#FFFFFF")
        configuration.successOverlay.message.text = "Scanned Successfully!"
        configuration.successOverlay.message.color = SBSDKUI2Color(colorString: "#FFFFFF")
        
        // Configure the sound.
        configuration.sound.successBeepEnabled = true
        configuration.sound.soundType = .modernBeep
        
        // Configure the vibration.
        configuration.vibration.enabled = false
        
        // Present the view controller modally.
        do {
            let result = try await SBSDKUI2VINScannerViewController.present(on: self, configuration: configuration)
            
            // Handle the result.
            print(result.textResult.rawText)
            print(result.textResult.confidence)
            print(result.textResult.validationSuccessful)
            
            // If expecting VIN from barcode.
            print(result.barcodeResult.extractedVIN)
            print(result.barcodeResult.status)
            print(result.barcodeResult.rectangle)
        }
        catch SBSDKError.operationCanceled {
            print("The operation was cancelled before completion or by the user")
            
        } catch {
            // Any other error
            print("Error scanning VIN: \(error.localizedDescription)")
        }
    }
}
