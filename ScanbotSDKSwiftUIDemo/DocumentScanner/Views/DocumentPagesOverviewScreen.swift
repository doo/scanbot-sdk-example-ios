//
//  DocumentPagesOverviewScreen.swift
//  DocumentScannerSwiftUIDemo (iOS)
//
//  Created by Danil Voitenko on 02.08.21.
//

import SwiftUI
import ScanbotSDK

struct DocumentPagesOverviewScreen: View {
    
    @ObservedObject var pagesContainer: DocumentPagesContainer
    @State private var isShowingModal = false
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem(.flexible())]) {
                ForEach(pagesContainer.pages) { page in
                    Button(action: {
                        pagesContainer.selectedPage = page
                        isShowingModal.toggle()
                    }){
                        if let image = page.documentImage() {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .padding(.vertical, 10)
                                .frame(width: 100)
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $isShowingModal) {
            DocumentPageEditingView(editingPage: $pagesContainer.selectedPage)
                .ignoresSafeArea()
        }
        .frame(height: 120)
    }
}
