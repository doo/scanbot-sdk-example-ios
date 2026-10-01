//
//  SoundControllerSwiftUIView.swift
//  ScanbotSDK Examples
//

import SwiftUI
import ScanbotSDK

struct SoundControllerSwiftUIView: View {
    
    var body: some View {
        Text("Sound Controller")
            .task {
                playSounds()
            }
    }
    
    func playSounds() {
        
        // Initialize the sound controller.
        let soundController = SBSDKSoundController()
        
        // Play beep sound.
        soundController.playBleepSound()
            
        // Vibrate the device using the haptics engine.
        soundController.vibrate()  
        
        // To play a custom sound, load the sound resource and get its URL.
        guard let url = Bundle.main.url(forResource: "sound", withExtension: "m4a") else { return }
        
        // Play the custom sound by passing the sound file's URL.
        soundController.playCustomSound(from: url)
    }
}

#Preview {
    SoundControllerSwiftUIView()
}
