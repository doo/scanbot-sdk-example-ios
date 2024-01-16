//
//  BarcodeScannerListView.swift
//  BarcodeScannerListView
//
//  Created by Danil Voitenko on 20.07.21.
//

import SwiftUI
import ScanbotSDK

extension SBSDKBarcodeScannerResult {
    var identifier: String {
        return self.rawTextStringWithExtension + "_" + self.type.name
    }
}

struct BarcodeScannerListView: View {
    
    private let scanners = BarcodeScanner.allCases
    
    @State private var scannedResult = BarcodeScanningResult(scannedBarcodes: [])
    @State private var selectedScanner: BarcodeScanner?
    @State private var shouldCleanResults = false
    
    var body: some View {
        List {
            Section {
                ForEach(scanners) { scanner in
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
            if !scannedResult.scannedBarcodes.isEmpty {
                Section(header: Text("Results by \(scannedResult.barcodeScannerName)")) {
                    ForEach(scannedResult.scannedBarcodes, id: \.identifier) { barcode in
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
                    scannedResult = BarcodeScanningResult(scannedBarcodes: [])
                }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle(Text("Barcode scanners"), displayMode: .inline)
        .onDisappear {
            if shouldCleanResults {
                scannedResult = BarcodeScanningResult(scannedBarcodes: [])
            }
        }
    }
}

struct ScannerListView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScannerListView()
    }
}
