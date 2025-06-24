//
//  UINavigationBar+Extension.swift
//  DocumentScannerRTUUIExample
//
//  Created by Seifeddine Bouzid on 11.10.24.
//

import UIKit

extension UINavigationBar {
    static func applyCustomNavigationStyle() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "AccentColor")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let navigationBarAppearance = self.appearance()
        navigationBarAppearance.tintColor = .white
        navigationBarAppearance.standardAppearance = appearance
        navigationBarAppearance.scrollEdgeAppearance = navigationBarAppearance.standardAppearance
    }
}
