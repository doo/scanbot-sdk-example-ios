//
//  BarcodeStableImageCounterViewController.swift
//  ScanbotSDKDemo
//
//  Created by Rana Sohaib on 11.04.23.
//  Copyright © 2023 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class BarcodeStableImageCounterViewController: UIViewController, SBSDKDocumentScannerViewControllerDelegate {
    
    @IBOutlet private var cameraView: UIView!
    @IBOutlet private var tableView: UITableView!
    
    private var scannerViewController: SBSDKDocumentScannerViewController?
    private var barcodeScanner: SBSDKBarcodeScanner?
    private var barcodeScannerTypes = SBSDKBarcodeType.allTypes()
    private var barcodeResults = [SBSDKBarcodeScannerResult]()
    private var barcodePolygonShapeLayers = [CAShapeLayer]()
    
    private var isShowingResult = false {
        didSet { scannerViewController?.hideSnapButton = isShowingResult }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scannerViewController = SBSDKDocumentScannerViewController(parentViewController: self,
                                                                   parentView: cameraView, 
                                                                   delegate: self)

        scannerViewController?.autoSnappingMode = .disabled
        scannerViewController?.suppressDetectionStatusLabel = true
        if let configuration = scannerViewController?.generalConfiguration {
            configuration.photoQualityPriorization = .speed
            scannerViewController?.generalConfiguration = configuration
        } 
        
        barcodeScanner = SBSDKBarcodeScanner(types: barcodeScannerTypes)
    }
    
    func documentScannerViewControllerShouldDetectDocument(_ controller: SBSDKDocumentScannerViewController) -> Bool {
        return false
    }
    
    func documentScannerViewController(_ controller: SBSDKDocumentScannerViewController, 
                                       didSnapDocumentImage documentImage: UIImage, 
                                       on originalImage: UIImage, 
                                       with result: SBSDKDocumentDetectorResult, 
                                       autoSnapped: Bool) {
        
        scannerViewController?.freezeCamera()

        let results = self.barcodeScanner?.detectBarCodes(on: originalImage)
        
        guard let results = results, !results.isEmpty else {
            self.reset()
            return
        }
        
        isShowingResult = true 
        
        drawPolygons(for: results, on: originalImage)
        barcodeResults = results
        tableView.reloadData()
        reset(withDelay: 3)
    }
    
    private func drawPolygons(for barcodes: [SBSDKBarcodeScannerResult], on image: UIImage) {
        barcodes.forEach { result in
            // bezier path of barcode on image
            guard let bezierPath = result.polygon.bezierPath(for: image.size) else { return }
            
            // transform to camera view coordinate system
            let transform = CGAffineTransform(scaleX: cameraView.bounds.size.width/image.size.width,
                                                  y: cameraView.bounds.size.height/image.size.height)
            bezierPath.apply(transform)
                
            // show polygon on camera view
            let shapeLayer = self.shapeLayer(for: bezierPath)
            barcodePolygonShapeLayers.append(shapeLayer)
            cameraView.layer.insertSublayer(shapeLayer,
                                            at: UInt32(cameraView.layer.sublayers?.count ?? 0))
        }
    }
    
    private func shapeLayer(for bezierPath: UIBezierPath) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.strokeColor = UIColor.cyan.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2.0
        return shapeLayer
    }
    
    private func reset(withDelay delay: Int = 0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) { [weak self] in
            self?.barcodeResults.removeAll()
            self?.barcodePolygonShapeLayers.forEach { $0.removeFromSuperlayer() }
            self?.barcodePolygonShapeLayers.removeAll()
            self?.tableView.reloadData()
            self?.scannerViewController?.unfreezeCamera()
            self?.isShowingResult = false
        }
    }
}

extension BarcodeStableImageCounterViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barcodeResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "barCodeResultCell", for: indexPath) as!
        BarcodeScannerResultsTableViewCell
        
        let result = barcodeResults[indexPath.row]
        
        cell.barcodeTextLabel?.text = result.rawTextStringWithExtension
        cell.barcodeTypeLabel?.text = result.type.name
        cell.barcodeImageView?.image = result.barcodeImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44.0
    }
}
