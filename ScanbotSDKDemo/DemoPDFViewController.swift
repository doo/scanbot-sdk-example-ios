//
//  DemoPDFViewController.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 25.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import PDFKit
import ScanbotSDK

class DemoPDFViewController: UIViewController {
    @IBOutlet private var pdfView: PDFView?
    private var pdfUrl: URL?
    
    static func make(with pdfUrl: URL) -> DemoPDFViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pdfViewController = storyboard.instantiateViewController(withIdentifier: "DemoPDFViewController") as!
        DemoPDFViewController
        pdfViewController.pdfUrl = pdfUrl
        
        return pdfViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pdfView?.displayMode = .singlePageContinuous
        pdfView?.autoScales = true
        pdfView?.displayDirection = .vertical
        if let pdfUrl = pdfUrl {
            pdfView?.document = PDFDocument(url: pdfUrl)
        }
    }
    
    @IBAction func shareButtonDidPress(_ sender: Any) {
        if let pdfUrl = pdfUrl {
            let activityController = UIActivityViewController(activityItems: [pdfUrl], applicationActivities: nil)
            present(activityController, animated: true, completion: nil)
        }
    }
}
