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
    private var barcodeResults: [SBSDKBarcodeScannerResult]?
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
            
            guard let image else {
                self?.refreshState()
                return
            }
            
            // freeze the camera
            self?.scannerViewController?.freezeCamera()
            
            // get results from the detector
            self?.barcodeResults = self?.barcodeScanner?.detectBarCodes(on: image)
            
            guard let results = self?.barcodeResults, !results.isEmpty else {
                self?.refreshState()
                return
            }
            
            // draw polygons present on the image, onto to the camera view
            self?.drawPolygons(for: self?.barcodeResults, on: image)
            
            // populate barcode results on the list
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
            
            // refresh after 3 seconds
            self?.refreshState(withDelay: 3)
        })
    }
    
    private func drawPolygons(for barcodes: [SBSDKBarcodeScannerResult]?, on image: UIImage) {
        self.barcodeResults?.forEach({ result in
            DispatchQueue.main.async { [weak self] in
                
                // bezier path of barcode on image
                guard let bezierPath = result.polygon.bezierPath(for: image.size),
                      let self else { return }
                
                // transform to camera view coordinate system
                let transform = CGAffineTransform(scaleX: self.cameraView.bounds.size.width/image.size.width,
                                                  y: self.cameraView.bounds.size.height/image.size.height)
                bezierPath.apply(transform)
                
                // show polygon on camera view
                let shapeLayer = self.shapeLayer(for: bezierPath)
                self.barcodePolygonShapeLayers.append(shapeLayer)
                self.cameraView.layer.insertSublayer(shapeLayer,
                                                     at: UInt32(self.cameraView.layer.sublayers?.count ?? 0))
            }
        })
    }
    
    private func shapeLayer(for bezierPath: UIBezierPath) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.strokeColor = UIColor.cyan.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2.0
        return shapeLayer
    }
    
    private func refreshState(withDelay delay: Int = 0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) { [weak self] in
            self?.barcodeResults?.removeAll()
            self?.barcodePolygonShapeLayers.forEach({$0.removeFromSuperlayer()})
            self?.barcodePolygonShapeLayers.removeAll()
            self?.tableView.reloadData()
            self?.scannerViewController?.unfreezeCamera()
            self?.isShowingResult = false
        }
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
