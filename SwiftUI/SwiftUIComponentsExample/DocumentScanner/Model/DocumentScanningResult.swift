//
//  DocumentScanningResult.swift
//  SwiftUIComponentsExample
//
//  Created by Rana Sohaib on 27.08.24.
//

import ScanbotSDK

final class DocumentScanningResult: ObservableObject {
    
    @Published var pages: [SBSDKScannedPage] = []
    @Published var selectedPage: SBSDKScannedPage?
    @Published var error: Error?
    
    /// Incremented whenever a page has been modified, so that the previews are redrawn.
    @Published private(set) var revision = 0

    private var scannedDocument: SBSDKScannedDocument?

    var documentUUID: String? {
        return scannedDocument?.uuid
    }
    
    init() {
        do {
            self.scannedDocument = try SBSDKScannedDocument(documentImageSizeLimit: 0)
        } catch {
            self.error = error
        }
    }
    
    init(scannedDocument: SBSDKScannedDocument) {
        self.scannedDocument = scannedDocument
        self.pages = scannedDocument.pages
    }
    
    init(error: Error) {
        self.error = error
    }
    
    /// Reloads the pages of the document and forces the previews to be redrawn.
    func refresh() {
        pages = scannedDocument?.pages ?? []
        revision += 1
    }
    
    /// Adds an imported image as a new page to the document.
    func addPage(image: SBSDKImageRef) throws {
        guard let scannedDocument else { return }
        _ = try scannedDocument.addPage(with: image)
        refresh()
    }
}

extension SBSDKScannedPage: @retroactive Identifiable { }
