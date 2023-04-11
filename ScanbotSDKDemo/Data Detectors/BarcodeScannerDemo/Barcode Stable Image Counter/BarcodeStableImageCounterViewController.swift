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
    @IBOutlet private var listTableView: UITableView!
    
    private var scannerViewController: SBSDKBarcodeScannerViewController?
    private var barcodeScanner: SBSDKBarcodeScanner?
    private var barcodeScannerTypes = SBSDKBarcodeType.allTypes()
    private var barcodeResults: [SBSDKBarcodeScannerResult]?
    private var barcodePolygonShapeLayers = [CAShapeLayer]()

    override func viewDidLoad() {
        super.viewDidLoad()

        scannerViewController = SBSDKBarcodeScannerViewController(parentViewController: self,
                                                                  parentView: cameraView)
        scannerViewController?.acceptedBarcodeTypes = barcodeScannerTypes
        scannerViewController?.selectionOverlayEnabled = false
        scannerViewController?.automaticSelectionEnabled = false
        
        barcodeScanner = SBSDKBarcodeScanner(types: barcodeScannerTypes)
    }
    
    @IBAction func captureCountBtn(sender: UIButton) {
        scannerViewController?.captureJPEGStillImage(completionHandler: { image, _ in
            if let image {
                
                // freeze the camera
                self.scannerViewController?.freezeCamera()
                
                // get results from the detector
                self.barcodeResults = self.barcodeScanner?.detectBarCodes(on: image)
                
                // draw polygons
                self.drawPolygonsFrom(image: image)
                
                // populate barcode results on the list
                DispatchQueue.main.async {
                    self.listTableView.reloadData()
                }
                
                // unfreeze camera after 3 seconds and refresh scanner
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.barcodeResults?.removeAll()
                    self.barcodePolygonShapeLayers.forEach({$0.removeFromSuperlayer()})
                    self.barcodePolygonShapeLayers.removeAll()
                    self.listTableView.reloadData()
                    self.scannerViewController?.unfreezeCamera()
                }
            }
        })
    }
    
    private func drawPolygonsFrom(image: UIImage) {
        self.barcodeResults?.forEach({ result in
            DispatchQueue.main.async {
                
                // bezier path of barcode on image
                guard let bezierPath = result.polygon.bezierPath(for: image.size) else { return }
                
                // transform to camera view coordinate system
                let transform = CGAffineTransform(scaleX: self.cameraView.bounds.size.width/image.size.width,
                                                  y: self.cameraView.bounds.size.height/image.size.height)
                bezierPath.apply(transform)
                
                // show polygon on camera view
                let shapeLayer = self.shapeLayerFor(bezierPath: bezierPath)
                self.barcodePolygonShapeLayers.append(shapeLayer)
                self.cameraView.layer.insertSublayer(shapeLayer,
                                                     at: UInt32(self.cameraView.layer.sublayers?.count ?? 0))
            }
        })
    }
    
    private func shapeLayerFor(bezierPath path: UIBezierPath) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.cyan.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2.0
        return shapeLayer
    }
}

extension BarcodeStableImageCounterViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        barcodeResults?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "barCodeResultCell", for: indexPath) as!
        BarcodeScannerResultsTableViewCell
        
        cell.barcodeTextLabel?.text = barcodeResults?[indexPath.row].rawTextStringWithExtension
        cell.barcodeTypeLabel?.text = barcodeResults?[indexPath.row].type.name
        cell.barcodeImageView?.image = barcodeResults?[indexPath.row].barcodeImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100.0
    }
}
