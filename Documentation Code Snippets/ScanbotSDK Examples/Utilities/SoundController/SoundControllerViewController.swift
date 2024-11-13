//
//  SoundControllerViewController.swift
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 06.12.22.
//

import UIKit
import ScanbotSDK

class SoundControllerViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the sound controller.
        let soundController = SBSDKSoundController()
        
        // Play beep sound.
        soundController.playBleepSound()
            
        // Vibrate the device using the haptics engine.
        soundController.vibrate()  
        
        // To play a custom sound load the sound resource and get the URL of it.
        guard let url = Bundle.main.url(forResource: "sound", withExtension: "m4a") else { return }
        
        // Play the custom sound by passing the sound files URL.
        soundController.playCustomSound(from: url)
    }
}
