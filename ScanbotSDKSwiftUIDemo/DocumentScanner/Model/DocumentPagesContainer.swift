//
//  DocumentPagesContainer.swift
//  DocumentScannerSwiftUIDemo (iOS)
//
//  Created by Danil Voitenko on 02.08.21.
//

import Foundation
import ScanbotSDK

final class DocumentPagesContainer: ObservableObject {
        
    @Published private(set) var pages: [SBSDKUIPage]
    @Published var selectedPage: SBSDKUIPage?
    
    private let accessQueue: DispatchQueue = DispatchQueue(label: "PagesViewModel.access")
    
    init(_ pages: [SBSDKUIPage] = []) {
        self.pages = pages
    }
    
    func add(page: SBSDKUIPage) {
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

extension SBSDKUIPage: Identifiable {
    public var id: UUID {
        return self.pageFileUUID
    }
}

