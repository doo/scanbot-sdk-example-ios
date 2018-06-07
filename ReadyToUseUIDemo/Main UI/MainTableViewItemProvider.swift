//
//  MainTableViewItem.swift
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 06.06.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

import Foundation

struct MainTableViewItem {
    let title: String
    let action: () -> (Void)
}

class MainTableViewItemProvider {
    
    let actionHandler: MainTableActionHandler
    let items: [MainTableViewItem]

    init(actionHandler: MainTableActionHandler) {
        self.actionHandler = actionHandler
        self.items = MainTableViewItemProvider.createActions(actionHandler)
    }
    
    private class func createActions(_ actionHandler: MainTableActionHandler) -> [MainTableViewItem] {
        let docScanItem = MainTableViewItem(title: "Scan Documents",
                                            action: { actionHandler.showDocumentScanning() })
        
        let qrScanItem = MainTableViewItem(title: "Scan QR Codes",
                                           action: { actionHandler.showQRCodeScanning() })
        
        let barcodeScanItem = MainTableViewItem(title: "Scan Barcodes",
                                                action: { actionHandler.showBarcodeScanning() })
        
        let mrzScanItem = MainTableViewItem(title: "Scan Machine Readable Zones",
                                            action: { actionHandler.showMRZScanning() })
        
        let cropItem = MainTableViewItem(title: "Crop Image from Photo Library",
                                         action: { actionHandler.showCropping() })
        
        let showItem =  MainTableViewItem(title: "Show all Images",
                                          action: { actionHandler.showAllImages() })
        
        let deleteItem = MainTableViewItem(title: "Delete all Images",
                                           action: { actionHandler.deleteAllImages() })

        return [docScanItem, qrScanItem, barcodeScanItem, mrzScanItem, cropItem, showItem, deleteItem];
    }
}
