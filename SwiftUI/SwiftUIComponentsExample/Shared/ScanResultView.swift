//
//  ScanResultView.swift
//  SwiftUIComponentsExample
//
//  A generic result screen that is reused by all scanner examples.
//

import SwiftUI

struct ScanResultView: View {
    
    let result: ScanResult
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                if !result.images.isEmpty {
                    Section(header: Text("Images")) {
                        ForEach(Array(result.images.enumerated()), id: \.offset) { _, image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 220)
                        }
                    }
                }
                if !result.fields.isEmpty {
                    Section(header: Text("Fields")) {
                        ForEach(result.fields) { field in
                            VStack(alignment: .leading, spacing: 2) {
                                Text(field.name)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(field.value.isEmpty ? "-" : field.value)
                            }
                        }
                    }
                }
                if let rawJSON = result.rawJSON, !rawJSON.isEmpty {
                    Section(header: Text("Raw result")) {
                        Text(rawJSON)
                            .font(.system(.footnote, design: .monospaced))
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle(Text(result.title), displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
