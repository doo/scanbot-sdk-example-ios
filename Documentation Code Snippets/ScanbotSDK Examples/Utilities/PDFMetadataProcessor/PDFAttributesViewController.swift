//
//  PDFAttributesViewController.swift
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 02.12.22.
//

import UIKit
import ScanbotSDK

class PDFAttributesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the URL of your desired pdf file.
        guard let url = Bundle.main.url(forResource: "document", withExtension: "pdf") else { return }
        
        // Read the pdf metadata attributes from the PDF at the url.
        let attributes = SBSDKPDFAttributes(pdfURL: url)!
        
        // Change the pdf attributes.
        attributes.title = "A Scanbot Demo PDF"
        attributes.author = "ScanbotSDK Development"
        attributes.creator = "ScanbotSDK for iOS"
        attributes.subject = "A demonstration of ScanbotSDK PDF creation."
        attributes.keywords = "PDF, Scanbot, SDK"
        
        // Inject the new pdf metadata attributes into your pdf at the same url.
        do {
            try attributes.saveToPDFFile(at: url)
        }
        catch {
            // Catch the error.
        }
    }
}
