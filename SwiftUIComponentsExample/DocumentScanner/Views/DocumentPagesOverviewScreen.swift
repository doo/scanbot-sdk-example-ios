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
                    if let image = page.documentImagePreview {
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
                    }
                }
            }
        }
        .fullScreenCover(item: $scanningResult.selectedPage, content: { page in
            SBSDKUI2CroppingView(
                configuration: SBSDKUI2CroppingConfiguration(
                    documentUuid: scanningResult.documentUUID,
                    pageUuid: page.uuid
                ), completion: nil
            )
        })
        .frame(height: 120)
    }
}
