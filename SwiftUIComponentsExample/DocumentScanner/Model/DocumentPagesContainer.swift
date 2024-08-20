//
//  DocumentPagesContainer.swift
//  SwiftUIComponentsExample
//
//  Created by Danil Voitenko on 02.08.21.
//

import Foundation
import ScanbotSDK

final class DocumentPagesContainer: ObservableObject {
        
    @Published private(set) var pages: [SBSDKDocumentPage]
    @Published var selectedPage: SBSDKDocumentPage?
    
    private let accessQueue: DispatchQueue = DispatchQueue(label: "PagesViewModel.access")
    
    init(_ pages: [SBSDKDocumentPage] = []) {
        self.pages = pages
    }
    
    func add(page: SBSDKDocumentPage) {
        accessQueue.sync {
            if !pages.contains(page) {
                pages.insert(page, at: 0)
            }
        }
    }
    
    func remove(at index: Int) {
        accessQueue.sync {
            if index < pages.count {
                _ = pages.remove(at: index)
            }
        }
    }
}

extension SBSDKDocumentPage: Identifiable {
    public var id: UUID {
        return self.pageFileUUID
    }
}

