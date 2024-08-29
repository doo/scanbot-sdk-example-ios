//
//  ScannedPageProcessingSwiftViewController.swift
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 29.08.24.
//

import Foundation
import ScanbotSDK

class ScannedPageProcessingSwiftViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        applyFiltersAndRotateScannedPage()
    }
    
    func applyFiltersAndRotateScannedPage() {
        
        // Retrieve the scanned document
        guard let document = SBSDKScannedDocument(documentUuid: "SOME_SAVED_UUID") else { return }
        
        // Retrieve the selected document page.
        guard let page = document.page(at: 0) else { return }
        
        // Apply rotation on the page, and you can also pass the filters here if you want
        page.apply(rotation: .clockwise90, polygon: nil, filters: nil)
        
        
        // Or you can also set the filters separately
        
        // Create the instances of the filters you want to apply.
        let filter1 = SBSDKScanbotBinarizationFilter(outputMode: .antialiased)
        let filter2 = SBSDKBrightnessFilter(brightness: 0.4)
        
        // Set the filters
        page.filters = [filter1, filter2]
    }
}
