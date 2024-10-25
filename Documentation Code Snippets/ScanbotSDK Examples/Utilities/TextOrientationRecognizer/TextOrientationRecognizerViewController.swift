//
//  TextOrientationRecognizerViewController.swift
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 02.12.22.
//

import UIKit
import ScanbotSDK

class TextOrientationRecognizerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize an instance of the recognizer.
        let recognizer = SBSDKTextLayoutRecognizer()
        
        // Set the desired image.
        if let image = UIImage(named: "testDocument") {
            
            // Recognize the text orientation.
            let oldOrientation = recognizer.recognizeTextOrientation(on: image)
            
            // Handle the result.
            self.printOrientationResult(orientation: oldOrientation)
            
            // Recognize the text orientation, but request a minimum confidence of 2.0.
            let orientationWithConfidence = recognizer.recognizeTextOrientation(on: image, with: 2.0)
            
            // Handle the result.
            self.printOrientationResult(orientation: orientationWithConfidence)
            
            // Rotate the image to portrait mode if possible.
            let newImage = self.rotateImageToPortraitMode(image: image, orientation: orientationWithConfidence)
        }
    }
    
    // Rotate the image according to the recognized orientation.
    func rotateImageToPortraitMode(image: UIImage, orientation: SBSDKTextOrientation) -> UIImage? {
        switch orientation {
        case .notRecognized, .lowConfidence, .up:
            return image
        case .right:
            return image.sbsdk_imageRotatedCounterClockwise(1)
        case .down:
            return image.sbsdk_imageRotatedClockwise(2)
        case .left:
            return image.sbsdk_imageRotatedCounterClockwise(3)
        default:
            return image
        }
    }
    
    // Print the recognized orientation to the console.
    func printOrientationResult(orientation: SBSDKTextOrientation) {
        switch orientation {
            case .notRecognized:
                print("Text orientation was not recognized (bad image quality, etc).")
            case .lowConfidence:
                print("Text were recognized, but the confidence of recognition is too low.")
            case .up:
                print("Text is not rotated.")
            case .right:
                print("Text is rotated 90 degrees clockwise.")
            case .down:
                print("Text is rotated 180 degrees clockwise.")
            case .left:
                print("Text is rotated 270 degrees clockwise.")
            default:
                print(orientation.rawValue)
        }
    }
}
