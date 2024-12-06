//
//  MainTableViewItem.swift
//  DataCaptureRTUUIExample
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

        let textScanItem = MainTableViewItem(title: "Extract text data",
                                             action: { actionHandler.showTextPatternScanner() })
        
        let checkRecognizeItem = MainTableViewItem(title: "Scan Check",
                                              action: { actionHandler.showCheckScanner() })
        
        let mrzScanItem = MainTableViewItem(title: "Scan Machine Readable Zone",
                                            action: { actionHandler.showMRZScanning() })

        let licensePlateScanItem = MainTableViewItem(title: "Scan EU License Plate",
                                                     action: { actionHandler.showLicensePlateScanner() })
        
        let vinScanItem = MainTableViewItem(title: "Scan Vehicle Identification Number",
                                            action: { actionHandler.showVinScanner() })
        
        let items2 = [mrzScanItem, textScanItem, checkRecognizeItem, licensePlateScanItem, vinScanItem]
        
        let ehicScanItem = MainTableViewItem(title: "Scan Health Insurance Card",
                                            action: { actionHandler.showEHICScanning() })
        
        let medicalCertificateScanItem = MainTableViewItem(title: "Scan Medical Certificate",
                                                           action: { actionHandler.showMedicalCertificateScanning() })
        

        let items3 = [ehicScanItem, medicalCertificateScanItem]
        
        
        let idCardItem = MainTableViewItem(title: "Scan German ID card",
                                           action: { actionHandler.showIDCardScanner() })

        let driverLicenseItem = MainTableViewItem(title: "Scan German driver's license",
                                                  action: { actionHandler.showDriverLicenseScanner() })
        
        let items4 = [idCardItem, driverLicenseItem]

        let viewScansItem = MainTableViewItem(title: "View Scans",
                                              action: { actionHandler.showAllImages() })
        
        let dataDetectorsSection = MainTableViewSection(title: "Data Detectors", items: items2)
        let healthDocumentsScannersSection = MainTableViewSection(title: "Health Documents Scanners", items: items3)
        let identityDetectorsSection = MainTableViewSection(title: "Identity Detectors", items: items4)
        let viewScansSection = MainTableViewSection(title: "Reviewable Scans", items: [viewScansItem])
                
        return [dataDetectorsSection, healthDocumentsScannersSection, identityDetectorsSection, viewScansSection]
    }
}
