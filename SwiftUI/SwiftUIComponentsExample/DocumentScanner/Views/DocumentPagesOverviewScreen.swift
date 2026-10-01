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
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem(.flexible())]) {
                ForEach(scanningResult.pages, id: \.uuid) { page in
                    if let image = try? page.documentImagePreview?.toUIImage() {
                        Button(action: { scanningResult.selectedPage = page }) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .padding(.vertical, 10)
                                .frame(width: 100)
                        }
                        // Redraw the preview whenever the page has been edited.
                        .id(scanningResult.revision)
                    } else {
                        Label("No Image", systemImage: "exclamationmark.triangle")
                    }
                }
            }
        }
        .fullScreenCover(item: $scanningResult.selectedPage) { page in
            DocumentPageDetailScreen(page: page, scanningResult: scanningResult)
        }
        .frame(height: 120)
    }
}

/// Lets the user crop a page with the ready-to-use UI cropping screen or edit it with the
/// native SwiftUI image editing component.
struct DocumentPageDetailScreen: View {
    
    let page: SBSDKScannedPage
    
    @ObservedObject var scanningResult: DocumentScanningResult
    
    @State private var isShowingCropping = false
    @State private var isShowingEditing = false
    @State private var error: ScannerError?
    
    var body: some View {
        NavigationView {
            VStack {
                if let image = try? page.documentImagePreview?.toUIImage() {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .padding()
                } else {
                    Spacer()
                    Label("No Image", systemImage: "exclamationmark.triangle")
                    Spacer()
                }
                
                Button("Crop (ready-to-use UI)") { isShowingCropping = true }
                    .padding(.bottom, 8)
                Button("Edit (native component)") { isShowingEditing = true }
                    .padding(.bottom)
            }
            .navigationBarTitle(Text("Page"), displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") { scanningResult.selectedPage = nil })
        }
        .fullScreenCover(isPresented: $isShowingCropping) {
            if let documentUUID = scanningResult.documentUUID {
                SBSDKUI2CroppingView(
                    configuration: SBSDKUI2CroppingStandaloneConfiguration(documentUuid: documentUUID,
                                                                          pageUuid: page.uuid),
                    completion: { _, _ in
                        isShowingCropping = false
                        scanningResult.refresh()
                    }
                )
            } else {
                Label("No document UUID", systemImage: "exclamationmark.triangle")
            }
        }
        .fullScreenCover(isPresented: $isShowingEditing) {
            DocumentPageEditingScreen(page: page,
                                      onFinish: { isShowingEditing = false; scanningResult.refresh() },
                                      onError: { error = ScannerError($0); isShowingEditing = false })
        }
        .alert(item: $error) { error in
            Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
        }
    }
}

/// Shows the native SwiftUI image editing component `SBSDKImageEditingView`.
struct DocumentPageEditingScreen: View {
    
    let page: SBSDKScannedPage
    let onFinish: () -> Void
    let onError: (Error) -> Void
    
    @State private var viewModel: SBSDKImageEditingViewModel?
    
    var body: some View {
        NavigationView {
            Group {
                if let viewModel {
                    SBSDKImageEditingView(viewModel: viewModel)
                } else {
                    Color.black
                }
            }
            .navigationBarTitle(Text("Edit page"), displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel", action: onFinish),
                                trailing: Button("Apply", action: apply))
        }
        .onAppear(perform: createViewModelIfNeeded)
    }
    
    private func createViewModelIfNeeded() {
        guard viewModel == nil else { return }
        guard let image = page.originalImage else {
            onError(NSError(domain: "SwiftUIComponentsExample", code: 1,
                            userInfo: [NSLocalizedDescriptionKey: "The page has no original image."]))
            return
        }
        viewModel = SBSDKImageEditingViewModel(image: image, polygon: page.polygon)
    }
    
    private func apply() {
        guard let viewModel else { return }
        
        // Normalize the number of rotations and apply them to the polygon and the page.
        var rotations = viewModel.rotations
        while rotations < 0 { rotations += 4 }
        
        let polygon = viewModel.polygon
        polygon.rotateCCW(UInt(rotations))
        
        page.polygon = polygon
        page.rotation = SBSDKImageRotation.fromRotations(viewModel.rotations)
        
        onFinish()
    }
}
