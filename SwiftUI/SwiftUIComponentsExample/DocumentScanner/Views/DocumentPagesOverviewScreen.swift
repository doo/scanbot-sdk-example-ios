//
//  DocumentPagesOverviewScreen.swift
//  SwiftUIComponentsExample
//
//  Created by Danil Voitenko on 02.08.21.
//

import SwiftUI
import ScanbotSDK

struct DocumentPagesOverviewScreen: View {
    
    @ObservedObject var scanningResult: DocumentScanningResult
    @State private var isShowingModal = false
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem(.flexible())]) {
                ForEach(scanningResult.pages, id: \.uuid) { page in
                    if let image = try? page.documentImagePreview?.toUIImage() {
                        Button(action: {
                            scanningResult.selectedPage = page
                            isShowingModal.toggle()
                        }){
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .padding(.vertical, 10)
                                .frame(width: 100)
                        }
                    } else {
                        Label("No Image", systemImage: "exclamationmark.triangle")
                    }
                }
            }
        }
        .fullScreenCover(item: $scanningResult.selectedPage, content: { page in
            if let documentUUID = scanningResult.documentUUID {
                SBSDKUI2CroppingView(
                    configuration: SBSDKUI2CroppingConfiguration(
                        documentUuid: documentUUID,
                        pageUuid: page.uuid
                    ), completion: { _, _ in }
                )
            } else {
                Label("No document UUID", systemImage: "exclamationmark.triangle")
            }
        })
        .frame(height: 120)
    }
}
