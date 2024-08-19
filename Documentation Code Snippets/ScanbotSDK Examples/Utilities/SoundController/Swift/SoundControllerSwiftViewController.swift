//
//  SoundControllerSwiftViewController.swift
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 06.12.22.
//

import UIKit
import ScanbotSDK

class SoundControllerSwiftViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Initialize the sound controller.
        let soundController = SBSDKSoundController()
        
        // Play the beep sound and vibrate after 2 seconds.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            
            // Beep.
            soundController.playBleepSound()
            
            // Vibrate.
            soundController.vibrate()  
        })
        
        
        // Play a sound from a custom url and vibrate after 3 seconds.
        guard let url = Bundle.main.url(forResource: "sound", withExtension: "m4a") else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            
            // Play custom sound.
            soundController.playCustomSound(from: url)
            
            // Vibrate.
            soundController.vibrate()
        })
    }
}
