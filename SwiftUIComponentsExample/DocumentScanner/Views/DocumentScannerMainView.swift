//
//  DocumentScannerMainView.swift
//  SwiftUIComponentsExample
//
//  Created by Danil Voitenko on 03.08.21.
//

import SwiftUI

struct DocumentScannerMainView: View {
    
    @StateObject var pagesContainer = DocumentPagesContainer()
    
    var body: some View {
            VStack {
                DocumentScannerView(pagesContainer: pagesContainer)
                DocumentPagesOverviewScreen(pagesContainer: pagesContainer)
            }
            .navigationBarTitle("Document Scanner", displayMode: .inline)
    }
}
