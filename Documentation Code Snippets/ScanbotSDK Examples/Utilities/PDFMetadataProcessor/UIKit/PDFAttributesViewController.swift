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
        
        // Get the URL of your desired PDF file.
        guard let url = Bundle.main.url(forResource: "document", withExtension: "pdf") else { return }
        
        // Read the PDF metadata attributes from the PDF at the URL.
        let attributes = SBSDKPDFAttributes(pdfURL: url)!
        
        // Change the PDF attributes.
        attributes.title = "A Scanbot Demo PDF"
        attributes.author = "ScanbotSDK Development"
        attributes.creator = "ScanbotSDK for iOS"
        attributes.subject = "A demonstration of ScanbotSDK PDF creation."
        attributes.keywords = "PDF, Scanbot, SDK"
        
        // Inject the new PDF metadata attributes into your PDF at the same URL.
        do {
            try attributes.saveToPDFFile(at: url)
        }
        catch {
            // Catch the error.
        }
    }
}
