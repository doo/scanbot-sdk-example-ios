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
        
        // Apply rotation on the page, and pass the filters, if needed.
        page.apply(rotation: .clockwise90, polygon: nil, filters: nil)
        
        
        // Or set the filters separately:
        // Create the instances of the filters you want to apply.
        let filter1 = SBSDKScanbotBinarizationFilter(outputMode: .antialiased)
        let filter2 = SBSDKBrightnessFilter(brightness: 0.4)
        
        // Apply the filters.
        page.filters = [filter1, filter2]
    }
}
