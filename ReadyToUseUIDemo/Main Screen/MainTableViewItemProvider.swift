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

struct MainTableViewSection {
    let title: String
    let items: [MainTableViewItem]
}

class MainTableViewItemProvider {
    
    let actionHandler: MainTableActionHandler
    let sections: [MainTableViewSection]

    init(actionHandler: MainTableActionHandler) {
        self.actionHandler = actionHandler
        self.sections = MainTableViewItemProvider.createItems(actionHandler)
    }
    
    private class func createItems(_ actionHandler: MainTableActionHandler) -> [MainTableViewSection] {

        let docScanItem = MainTableViewItem(title: "Scan Document",
                                            action: { actionHandler.showDocumentScanning() })
        
        let multipleObjectsItem = MainTableViewItem(title: "Multiple objects scanner",
                                                    action: { actionHandler.showMultipleObjectsScanning() })
        
        let importImageItem = MainTableViewItem(title: "Import Image",
                                                action: { actionHandler.showImportImages() })

        let viewImagesItem = MainTableViewItem(title: "View Images",
                                               action: { actionHandler.showAllImages() })
        
        let workflowItem = MainTableViewItem(title: "Workflow",
                                             action: { actionHandler.showWorkflow()})

        let items1 = [docScanItem, multipleObjectsItem, importImageItem, viewImagesItem, workflowItem]

        
        
        let qrScanItem = MainTableViewItem(title: "Scan QR-Code",
                                           action: { actionHandler.showQRCodeScanning() })
        
        let textScanItem = MainTableViewItem(title: "Extract text data",
                                             action: { actionHandler.showTextDataScanner() })
        
        let batchBarcodesItem = MainTableViewItem(title: "Scan Barcodes in batch",
                                                  action: { actionHandler.showBarcodeBatchScanner() })
        
        let idCardItem = MainTableViewItem(title: "Scan ID card",
                                           action: { actionHandler.showIDCardScanner() })
        
        let mrzScanItem = MainTableViewItem(title: "Scan Machine Readable Zone",
                                            action: { actionHandler.showMRZScanning() })

        let barcodeScanItem = MainTableViewItem(title: "Scan Bar Code",
                                                action: { actionHandler.showBarcodeScanning() })
        
        let ehicScanItem = MainTableViewItem(title: "Scan Health Insurance Card",
                                            action: { actionHandler.showEHICScanning() })

        let licensePlateScanItem = MainTableViewItem(title: "Scan License Plate",
                                                     action: { actionHandler.showLicensePlateScanner() })
        
        let items2 = [qrScanItem, mrzScanItem, idCardItem, batchBarcodesItem, barcodeScanItem, textScanItem,
                      ehicScanItem, licensePlateScanItem]
        
        let firstSection = MainTableViewSection(title: "", items: items1)
        let secondSection = MainTableViewSection(title: "", items: items2)
        
        return [firstSection, secondSection]
    }
}
