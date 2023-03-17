//
//  BarcodeScannerCustomCellViewController.swift
//  ScanbotSDKDemo
//
//  Created by Rana Sohaib on 17.03.23.
//  Copyright © 2023 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class BarcodeScannerCustomCellViewController: BarcodeScannerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scannerViewController?.selectionOverlayEnabled = true
        let cellNib = UINib(nibName: "BarcodeCustomCell", bundle: nil)
        scannerViewController?.enableSelectionOverlayCustomCellMode(cellNib, withIdentifier: "BarcodeCustomCell")
    }
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  didUpdateDetectedBarcodes codes: [SBSDKBarcodeScannerResult]) {
        
        addOrUpdateBarcodes(codes)
        removeOutdatedCodes()
    }
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  configureCustomCell cell: UICollectionViewCell,
                                  forBarcode code: SBSDKBarcodeScannerResult,
                                  withBarcodePolygonPath path: UIBezierPath) {
        
        let customCell = cell as! BarcodeCustomCell
        if let item: BarcodeItem = itemForBarcode(code) {
            switch item.contentStatus {
            case .loaded (let content):
                customCell.titleLabel.text = content
                customCell.indicator.stopAnimating()
            case .loading, .unloaded:
                customCell.titleLabel.text = ""
                customCell.indicator.startAnimating()
            }
        }
    }
    
    func barcodeScannerController(_ controller: SBSDKBarcodeScannerViewController,
                                  customCellFrameForProposedFrame frame: CGRect) -> CGRect {
        
        let size = frame.size
        return CGRect(center: frame.center, size: size)
    }
    
    var items: Set<BarcodeItem> = Set<BarcodeItem>()
    
    private func itemForBarcode(_ barcode: SBSDKBarcodeScannerResult) -> BarcodeItem? {
        let item = items.filter { $0.barcode.rawTextStringWithExtension == barcode.rawTextStringWithExtension }.first
        return item
    }
    
    private func addOrUpdateBarcodes(_ codes: [SBSDKBarcodeScannerResult]) {
        for code in codes {
            let item = itemForBarcode(code) ?? BarcodeItem(barcode: code)
            item.barcode = code
            items.insert(item)
        }
    }
    
    private func removeOutdatedCodes() {
        var itemsToRemove = [BarcodeItem]()
        for item in items {
            if item.barcode.age > 2.0 {
                itemsToRemove.append(item)
            }
        }
        for item in itemsToRemove {
            items.remove(item)
        }
    }
}

class BarcodeItem: Equatable, Hashable {
    
    enum ContentStatus {
        case unloaded
        case loading
        case loaded(String)
    }
    
    var barcode: SBSDKBarcodeScannerResult
    var contentStatus: ContentStatus
    
    init(barcode: SBSDKBarcodeScannerResult) {
        self.barcode = barcode
        self.contentStatus = .unloaded
        self.loadContents()
    }
    
    private func loadContents() {
        contentStatus = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.contentStatus = .loaded(self.barcode.rawTextStringWithExtension + "\n(\(self.barcode.type.name))")
        }
    }
    
    static func == (lhs: BarcodeItem, rhs: BarcodeItem) -> Bool {
        return lhs.barcode.rawTextStringWithExtension == rhs.barcode.rawTextStringWithExtension
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.barcode.rawTextStringWithExtension)
    }
}

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }
    
    init(center: CGPoint, size: CGSize) {
        let center = CGPoint(x: center.x - size.width * 0.5, y: center.y - size.height * 0.5)
        self.init(origin: center, size: size)
    }
}
