//
//  DataCaptureListView.swift
//  SwiftUIComponentsExample
//

import SwiftUI

struct DataCaptureListView: View {
    
    @State private var selectedScanner: DataCaptureScanner?
    
    var body: some View {
        List {
            Section(header: Text("Ready-to-use UI components")) {
                ForEach(DataCaptureScanner.readyToUseUIScanners) { scanner in
                    Button(action: { selectedScanner = scanner }) {
                        Text(scanner.title)
                            .foregroundColor(.primary)
                    }
                }
            }
            Section(header: Text("Classic components")) {
                ForEach(DataCaptureScanner.classicScanners) { scanner in
                    NavigationLink(destination: DataCaptureContainerView(scanner: scanner)) {
                        Text(scanner.title)
                    }
                }
            }
        }
        .fullScreenCover(item: $selectedScanner) { scanner in
            DataCaptureContainerView(scanner: scanner)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle(Text("Data capture"), displayMode: .inline)
    }
}
