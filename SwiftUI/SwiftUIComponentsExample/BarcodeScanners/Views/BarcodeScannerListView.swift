//
//  BarcodeScannerListView.swift
//  BarcodeScannerListView
//
//  Created by Danil Voitenko on 20.07.21.
//

import SwiftUI
import ScanbotSDK

struct BarcodeScannerListView: View {
    
    @State private var scannedResult = BarcodeScanningResult(scannedItems: [])
    @State private var selectedScanner: BarcodeScanner?
    @State private var shouldCleanResults = false
    
    var body: some View {
        List {
            Section(header: Text("Ready-to-use UI")) {
                ForEach(BarcodeScanner.readyToUseUIScanners) { scanner in
                    row(for: scanner)
                }
            }
            Section(header: Text("Classic component")) {
                ForEach(BarcodeScanner.classicScanners) { scanner in
                    row(for: scanner)
                }
            }
            if !scannedResult.scannedBarcodes.isEmpty {
                Section(header: Text("Results by \(scannedResult.barcodeScannerName)")) {
                    ForEach(scannedResult.scannedBarcodes, id: \.id) { barcode in
                        NavigationLink(destination: BarcodeScanResultDetailsView(scanResult: barcode)) {
                            BarcodeScannerResultsCellView(barcode: barcode)
                        }
                    }
                }
            }
        }
        .fullScreenCover(item: $selectedScanner) { scanner in
            BarcodeScannerContainerView(scanner: scanner,
                                        scanningResult: $scannedResult)
                .onAppear {
                    scannedResult = BarcodeScanningResult(scannedItems: [])
                }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle(Text("Barcode scanners"), displayMode: .inline)
        .onDisappear {
            if shouldCleanResults {
                scannedResult = BarcodeScanningResult(scannedItems: [])
            }
        }
    }
}

extension BarcodeScannerListView {
    
    @ViewBuilder
    fileprivate func row(for scanner: BarcodeScanner) -> some View {
        if scanner.shouldPresentModally {
            Button(action: { selectedScanner = scanner }) {
                Text(scanner.title)
                    .foregroundColor(.primary)
            }
        } else {
            NavigationLink(destination: BarcodeScannerContainerView(scanner: scanner,
                                                                    scanningResult: $scannedResult)
                            .onAppear { shouldCleanResults = true }
                            .onDisappear { shouldCleanResults = false }
            ) {
                Text(scanner.title)
            }
        }
    }
}

struct BarcodeScannerListView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScannerListView()
    }
}
