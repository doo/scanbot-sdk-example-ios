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
    
    private var scannedDocument: SBSDKScannedDocument
    
    var documentUUID: String {
        return scannedDocument.uuid
    }
    
    init(scannedDocument: SBSDKScannedDocument) {
        self.scannedDocument = scannedDocument
        self.pages = scannedDocument.pages
    }
}

extension SBSDKScannedPage: Identifiable { }
