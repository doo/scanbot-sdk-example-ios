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
        
        let viewImagesItem = MainTableViewItem(title: "View Images",
                                               action: { actionHandler.showAllImages() })
        
        let items1 = [docScanItem, multipleObjectsItem, viewImagesItem]
        

        let barcode2DScanItem = MainTableViewItem(title: "Scan 2D Barcodes",
                                           action: { actionHandler.showTwoDimensionalBarcodeScanning() })
        
        let barcode1DScanItem = MainTableViewItem(title: "Scan 1D Barcodes",
                                                action: { actionHandler.showOneDimensionalBarcodeScanning() })
        
        let batchBarcodesItemV3 = MainTableViewItem(title: "Scan Barcodes in batch (V3 Next Gen)",
                                                    action: { actionHandler.showBarcodeBatchScanner(engineMode: .nextGen) })
        
        let batchBarcodesItemV2 = MainTableViewItem(title: "Scan Barcodes in batch (V2 Legacy)",
                                                    action: { actionHandler.showBarcodeBatchScanner(engineMode: .legacy) })
        
        let textScanItem = MainTableViewItem(title: "Extract text data",
                                             action: { actionHandler.showTextDataScanner() })
        
        let mrzScanItem = MainTableViewItem(title: "Scan Machine Readable Zone",
                                            action: { actionHandler.showMRZScanning() })

        let licensePlateScanItem = MainTableViewItem(title: "Scan EU License Plate",
                                                     action: { actionHandler.showLicensePlateScanner() })
        
        let items2 = [barcode2DScanItem, barcode1DScanItem, batchBarcodesItemV3, batchBarcodesItemV2,
                      mrzScanItem, textScanItem, licensePlateScanItem]
        
        
        let ehicScanItem = MainTableViewItem(title: "Scan Health Insurance Card",
                                            action: { actionHandler.showEHICScanning() })
        let items3 = [ehicScanItem]
        
        
        let idCardItem = MainTableViewItem(title: "Scan German ID card",
                                           action: { actionHandler.showIDCardScanner() })

        let driverLicenseItem = MainTableViewItem(title: "Scan German driver's license",
                                                  action: { actionHandler.showDriverLicenseScanner() })
        
        let items4 = [idCardItem, driverLicenseItem]

        
        let workflowItem = MainTableViewItem(title: "Select a Workflow",
                                             action: { actionHandler.showWorkflow()})
        
        
        let documentScannersSection = MainTableViewSection(title: "Document Scanners", items: items1)
        let dataDetectorsSection = MainTableViewSection(title: "Data Detectors", items: items2)
        let healthDocumentsScannersSection = MainTableViewSection(title: "Health Documents Scanners", items: items3)
        let identityDetectorsSection = MainTableViewSection(title: "Identity Detectors", items: items4)
        let workflowsSection = MainTableViewSection(title: "Workflows", items: [workflowItem])
        
        return [documentScannersSection, dataDetectorsSection, healthDocumentsScannersSection,
                identityDetectorsSection, workflowsSection]
    }
}
