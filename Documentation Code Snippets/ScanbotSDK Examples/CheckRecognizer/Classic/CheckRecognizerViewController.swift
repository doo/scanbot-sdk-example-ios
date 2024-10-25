//
//  CheckRecognizerViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 27.04.22.
//

import UIKit
import ScanbotSDK

class CheckRecognizerViewController: UIViewController {
    
    // The instance of the recognizer view controller.
    private var recognizerViewController: SBSDKCheckRecognizerViewController?
    
    // The label to present the recognition status updates.
    @IBOutlet private var statusLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the SBSDKCheckRecognizerViewController instance.
        self.recognizerViewController = SBSDKCheckRecognizerViewController(parentViewController: self,
                                                                           parentView: self.view,
                                                                           delegate: self)
    }
}

extension CheckRecognizerViewController: SBSDKCheckRecognizerViewControllerDelegate {

    func checkRecognizerViewController(_ controller: SBSDKCheckRecognizerViewController,
                                       didRecognizeCheck result: SBSDKCheckRecognitionResult) {
        // Process the recognized result.
    }
    
    func checkRecognizerViewController(_ controller: SBSDKCheckRecognizerViewController,
                                       didChangeState state: SBSDKCheckRecognizerState) {
        
        // Update status label according to status
        switch state {
        case .searching:
            self.statusLabel?.text = "Looking for the check"
        case .recognizing:
            self.statusLabel?.text = "Recognizing the check"
        case .capturing:
            self.statusLabel?.text = "Capturing the check"
        case .energySaving:
            self.statusLabel?.text = "Energy saving mode"
        case .paused:
            self.statusLabel?.text = "Recognition paused"
        @unknown default:
            fatalError()
        }
    }
}
