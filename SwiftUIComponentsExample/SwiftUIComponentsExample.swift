//
//  SwiftUIComponentsExample.swift
//  SwiftUIComponentsExample
//
//  Created by Danil Voitenko on 14.10.21.
//

import SwiftUI
import ScanbotSDK

@main
struct SwiftUIComponentsExample: App {
        
    init() {
        Scanbot.setupDefaultLicenseFailureHandler()
    }
    
    var body: some Scene {
        WindowGroup {
            MainListView()
        }
    }
}
