//
//  DocumentExampleUISwiftViewController.swift
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 10.09.21.
//

import UIKit
import ScanbotSDK

class DocumentExampleUISwiftViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For this example we're going to create a mock scanned document image.
        guard let documentImage = UIImage(named: "documentImage") else { return }

        // Create a page with a UIImage instance.
        let page = SBSDKDocumentPage(image: documentImage, polygon: nil, filter: .none)

        // Return the result of the detected document on an image.
        let result = page.detectDocument(applyPolygonIfOkay: true)

        // Rotate the image 180 degrees clockwise. Negative values will rotate the image counter-clockwise.
        page.rotateClockwise(2)

        // Return the detected document preview image.
        let previewImage = page.documentPreviewImage

        // Return the url of the original image.
        let originalImageURL = page.originalImageURL

        // Create an empty document instance.
        let document = SBSDKDocument()

        // Add the page to the document.
        document.add(page)
        
        // Replace the first page of the document with the new page.
        document.replacePage(at: 0, with: page)

        // Remove the first page from the document.
        document.removePage(at: 0)

        // Find the index of the page by its identifier.
        let index = document.indexOfPage(withPageFileID: page.pageFileUUID)
    }
}
