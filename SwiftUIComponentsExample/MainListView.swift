//
//  MainListView.swift
//  SwiftUIComponentsExample
//
//  Created by Danil Voitenko on 14.10.21.
//

import SwiftUI

struct MainListView: View {
    
    var body: some View {
        NavigationView {
            List() {
                NavigationLink("Document Scanner") {
                    DocumentScannerMainView()
                }
                NavigationLink("Barcode Scanner") {
                    BarcodeScannerListView()
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Select Scanner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainListView()
    }
}
