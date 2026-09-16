//
//  ImageImportButton.swift
//  SwiftUIComponentsExample
//
//  Imports an image using only native SwiftUI components. On iOS 16 and later the
//  `PhotosPicker` is used, on earlier versions the SwiftUI `fileImporter` is used instead.
//

import SwiftUI
import UniformTypeIdentifiers
import ScanbotSDK
#if canImport(PhotosUI)
import PhotosUI
#endif

struct ImageImportButton: View {
    
    let title: String
    let onImport: (SBSDKImageRef) -> Void
    let onError: (Error) -> Void
    
    var body: some View {
        if #available(iOS 16.0, *) {
            PhotosPickerImportButton(title: title, onImport: onImport, onError: onError)
        } else {
            FileImporterImportButton(title: title, onImport: onImport, onError: onError)
        }
    }
}

@available(iOS 16.0, *)
private struct PhotosPickerImportButton: View {
    
    let title: String
    let onImport: (SBSDKImageRef) -> Void
    let onError: (Error) -> Void
    
    @State private var selection: PhotosPickerItem?
    
    var body: some View {
        PhotosPicker(title, selection: $selection, matching: .images)
            .onChange(of: selection) { item in
                guard let item else { return }
                loadImage(from: item)
            }
    }
    
    private func loadImage(from item: PhotosPickerItem) {
        item.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                selection = nil
                switch result {
                case .success(let data):
                    guard let data, let image = UIImage(data: data) else { return }
                    onImport(image.asImageRef)
                case .failure(let error):
                    onError(error)
                }
            }
        }
    }
}

private struct FileImporterImportButton: View {
    
    let title: String
    let onImport: (SBSDKImageRef) -> Void
    let onError: (Error) -> Void
    
    @State private var isPresented = false
    
    var body: some View {
        Button(title) { isPresented = true }
            .fileImporter(isPresented: $isPresented, allowedContentTypes: [UTType.image]) { result in
                switch result {
                case .success(let url):
                    load(url: url)
                case .failure(let error):
                    onError(error)
                }
            }
    }
    
    private func load(url: URL) {
        let needsAccess = url.startAccessingSecurityScopedResource()
        defer { if needsAccess { url.stopAccessingSecurityScopedResource() } }
        do {
            let data = try Data(contentsOf: url)
            guard let image = UIImage(data: data) else { return }
            onImport(image.asImageRef)
        } catch {
            onError(error)
        }
    }
}

extension UIImage {
    
    /// Converts the image into the image reference type used by the Scanbot SDK.
    var asImageRef: SBSDKImageRef {
        return SBSDKBaseScannerFrame(uiImage: self).toImageRef()
    }
}
