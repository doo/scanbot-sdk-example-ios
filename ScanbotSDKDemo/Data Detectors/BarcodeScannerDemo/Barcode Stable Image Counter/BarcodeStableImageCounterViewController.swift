//
//  BarcodeStableImageCounterViewController.swift
//  ScanbotSDKDemo
//
//  Created by Rana Sohaib on 11.04.23.
//  Copyright © 2023 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

class BarcodeStableImageCounterViewController: UIViewController {
    
    @IBOutlet private var cameraView: UIView!
    @IBOutlet private var tableView: UITableView!
    
    private var scannerViewController: SBSDKBarcodeScannerViewController?
    private var barcodeScanner: SBSDKBarcodeScanner?
    private var barcodeScannerTypes = SBSDKBarcodeType.allTypes()
    private var barcodeResults = [SBSDKBarcodeScannerResult]()
    private var barcodePolygonShapeLayers = [CAShapeLayer]()
    private var isShowingResult = false

    override func viewDidLoad() {
        super.viewDidLoad()

        scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                  parentView: cameraView)
        
        scannerViewController?.acceptedBarcodeTypes = barcodeScannerTypes
        scannerViewController?.selectionOverlayEnabled = false
        scannerViewController?.automaticSelectionEnabled = false
        
        barcodeScanner = SBSDKBarcodeScanner(types: barcodeScannerTypes)
    }
    
    @IBAction func captureButtonTapped(sender: UIButton) {
        guard !isShowingResult else { return }
        isShowingResult = true
        scannerViewController?.captureJPEGStillImage(completionHandler: { [weak self] image, _ in
            guard let image = image, let self else {
                self?.reset()
                return
            }  
                        
            // freeze the camera
            DispatchQueue.main.async { self.scannerViewController?.freezeCamera() }
            
            // get results from the detector
            let results = self.barcodeScanner?.detectBarCodes(on: image)
            
            guard let results = results, !results.isEmpty else {
                self.reset()
                return
            }
            
            // populate barcode results on the list
            DispatchQueue.main.async {
                self.drawPolygons(for: results, on: image)
                self.barcodeResults = results
                self.tableView.reloadData()
            }
            
            // refresh after 3 seconds
            self.reset(withDelay: 3)
        })
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
        100.0
    }
}
