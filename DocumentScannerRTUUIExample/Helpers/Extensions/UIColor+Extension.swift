//
//  UIColor+Extension.swift
//  DocumentScannerRTUUIExample
//
//  Created by Rana Sohaib on 08.09.23.
//

import UIKit

extension UIColor {
    
    static var appAccentColor: UIColor {
        return UIColor(named: "AccentColor") ?? UIColor(red: 200/255, green: 23/255, blue: 60/255, alpha: 1.0)
    }
}
