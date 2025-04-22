//
//  ScannedPageProcessingViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 29.08.24.
//

import Foundation
import ScanbotSDK

class ScannedPageProcessingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyFiltersAndRotateScannedPage()
    }
    
    func applyFiltersAndRotateScannedPage() {
        
        // Retrieve the scanned document.
        guard let document = SBSDKScannedDocument(documentUuid: "SOME_SAVED_UUID") else { return }
        
        // Retrieve the selected document page.
        guard let page = document.page(at: 0) else { return }

        // Create the instances of the filters you want to apply.
        let filter1 = SBSDKScanbotBinarizationFilter(outputMode: .antialiased)
        let filter2 = SBSDKBrightnessFilter(brightness: 0.4)

        // Apply individual changes using the properties of the page object.
        // E.g. rotate the page 90 degrees clockwise.
        page.rotation = .clockwise90
        
        // ... or set the polygon.
        page.polygon = SBSDKPolygon()
        
        // ... or apply filters.
        page.filters = [filter1, filter2]
        
        // If you want to apply multiple changes to the page at once, use the apply(...) function.
        // This will result in a faster performance than applying each change individually.
        page.apply(rotation: .clockwise90, polygon: SBSDKPolygon(), filters: [filter1, filter2])
    }
}
