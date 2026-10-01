//
//  UtilitiesListView.swift
//  SwiftUIComponentsExample
//

import SwiftUI
import ScanbotSDK

/// Lets the user import an image and run any of the still image detectors on it.
struct UtilitiesListView: View {
    
    @State private var importedImage: UIImage?
    @State private var importedImageRef: SBSDKImageRef?
    @StateObject private var state = ScannerSessionState()
    
    var body: some View {
        List {
            Section(header: Text("Image")) {
                ImageImportButton(title: importedImage == nil ? "Import an image" : "Import another image",
                                  onImport: { imageRef in
                                      importedImageRef = imageRef
                                      importedImage = imageRef.asUIImage
                                  },
                                  onError: { state.present(error: $0) })
                if let importedImage {
                    Image(uiImage: importedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 200)
                }
            }
            Section(header: Text("Detectors"),
                    footer: Text("Import an image first, then run a detector on it.")) {
                ForEach(UtilityDetector.allCases) { detector in
                    Button(action: { run(detector) }) {
                        Text(detector.title)
                            .foregroundColor(importedImageRef == nil ? .secondary : .primary)
                    }
                    .disabled(importedImageRef == nil)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle(Text("Utilities"), displayMode: .inline)
        .scannerSession(state)
    }
    
    private func run(_ detector: UtilityDetector) {
        guard let importedImageRef else { return }
        do {
            state.present(try detector.run(on: importedImageRef))
        } catch {
            state.present(error: error)
        }
    }
}
