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
}

extension SBSDKScannedPage: @retroactive Identifiable { }
