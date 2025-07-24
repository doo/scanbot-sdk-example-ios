//
//  DocumentScannerListView.swift
//  SwiftUIComponentsExample
//
//  Created by Rana Sohaib on 23.08.24.
//

import SwiftUI
import ScanbotSDK

struct DocumentScannerListView: View {
    
    private let scanners = DocumentScanner.allCases
    
    @State var scanningResult = DocumentScanningResult(scannedDocument: SBSDKScannedDocument())
    @State private var selectedScanner: DocumentScanner?
    @State private var shouldCleanResults = false
    
    var body: some View {
        VStack {
            List {
                Section {
                    ForEach(scanners) { scanner in
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
                }
                DocumentPagesOverviewScreen(scanningResult: scanningResult)
            }
        }
        .fullScreenCover(item: $selectedScanner) { scanner in
            DocumentScannerContainerView(scanner: scanner,
                                         scanningResult: $scanningResult)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle(Text("Document scanners"), displayMode: .inline)
        .onDisappear {
            if shouldCleanResults {
                scanningResult = DocumentScanningResult(scannedDocument: SBSDKScannedDocument())
            }
        }
    }
}

struct DocumentScannerListView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScannerListView()
    }
}
