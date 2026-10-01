//
//  DocumentScannerListView.swift
//  SwiftUIComponentsExample
//
//  Created by Rana Sohaib on 23.08.24.
//

import SwiftUI
import ScanbotSDK

struct DocumentScannerListView: View {
    
    @State var scanningResult = DocumentScanningResult()
    @State private var selectedScanner: DocumentScanner?
    @State private var shouldCleanResults = false
    @State private var importError: ScannerError?
    
    var body: some View {
        List {
            Section(header: Text("Ready-to-use UI")) {
                ForEach(DocumentScanner.readyToUseUIScanners) { scanner in
                    row(for: scanner)
                }
            }
            Section(header: Text("Classic component")) {
                ForEach(DocumentScanner.classicScanners) { scanner in
                    row(for: scanner)
                }
            }
            Section(header: Text("Import")) {
                ImageImportButton(title: "Import an image as a page",
                                  onImport: importPage(image:),
                                  onError: { importError = ScannerError($0) })
            }
            if !scanningResult.pages.isEmpty {
                Section(header: Text("Pages")) {
                    DocumentPagesOverviewScreen(scanningResult: scanningResult)
                }
            }
        }
        .fullScreenCover(item: $selectedScanner) { scanner in
            DocumentScannerContainerView(scanner: scanner,
                                         scanningResult: $scanningResult)
        }
        .alert(item: $importError) { error in
            Alert(title: Text("Error"), message: Text(error.message), dismissButton: .default(Text("OK")))
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle(Text("Document scanners"), displayMode: .inline)
        .onDisappear {
            if shouldCleanResults {
                scanningResult = DocumentScanningResult()
            }
        }
    }
    
    @ViewBuilder
    private func row(for scanner: DocumentScanner) -> some View {
        if scanner.shouldPresentModally {
            Button(action: { selectedScanner = scanner }) {
                Text(scanner.title)
                    .foregroundColor(.primary)
            }
        } else {
            NavigationLink(destination: DocumentScannerContainerView(scanner: scanner,
                                                                     scanningResult: $scanningResult)
                .onAppear { shouldCleanResults = true }
                .onDisappear { shouldCleanResults = false }
            ) {
                Text(scanner.title)
            }
        }
    }
    
    private func importPage(image: SBSDKImageRef) {
        do {
            try scanningResult.addPage(image: image)
        } catch {
            importError = ScannerError(error)
        }
    }
}

struct DocumentScannerListView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentScannerListView()
    }
}
