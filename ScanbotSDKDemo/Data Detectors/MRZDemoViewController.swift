//
//  MRZDemoViewController.swift
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 23.11.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

import UIKit
import ScanbotSDK

final class MRZDemoViewController: UIViewController {
    @IBOutlet private var imageView: UIImageView?
    @IBOutlet private var blackView: UIView?
    @IBOutlet private var cameraView: UIView?
    @IBOutlet private var textHintLabel: UILabel?
    
    private let recognizer = SBSDKMachineReadableZoneRecognizer()
    private lazy var cameraSession: SBSDKCameraSession = {
       let cameraSession = SBSDKCameraSession(for: FeatureMRZRecognition)
        cameraSession.videoDelegate = self
        cameraSession.captureSession?.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        return cameraSession
    }()
    private var isViewAppeared = false
    private var mrzRect: CGRect = .zero
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraSession.start()
        cameraView?.layer.insertSublayer(cameraSession.previewLayer, at: 0)
        isViewAppeared = true
        blackView?.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        cameraSession.stop()
        isViewAppeared = false
        blackView?.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let bounds = cameraView?.bounds {
            cameraSession.previewLayer.frame = bounds
        }
        recalculateMRZRect()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.recalculateMRZRect()
            self?.updateVideoOrientation()
        }, completion: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        updateVideoOrientation()
    }
    
    private func shouldRecognize() -> Bool {
        return isViewAppeared && imageView?.image == nil && presentedViewController == nil
    }
    
    private func recalculateMRZRect() {
        let aspectRatio: CGFloat = 1.47
        let edgeMargin: CGFloat = 15.0
        
        guard let frame = cameraView?.frame else { return }
        
        let heightLimit = frame.size.height - (edgeMargin * 2)
        let widthLimit = frame.size.width - (edgeMargin * 2)
        
        var targetHeight = widthLimit/aspectRatio
        var targetWidth = widthLimit
        
        if targetHeight > heightLimit {
            targetHeight = heightLimit
            targetWidth = heightLimit * aspectRatio
        }
        
        let targetSize = CGSize(width: targetWidth, height: targetHeight)
        let targetPoint = CGPoint(x: frame.size.width / 2 - targetSize.width / 2,
                                  y: frame.size.height / 2 - targetSize.height / 2)
        let targetRect = CGRect(x: targetPoint.x, y: targetPoint.y, width: targetSize.width, height: targetSize.height)
        
        let isLandscape = frame.size.height < frame.size.width
        let screenSize = frame.size
        let imageSize = isLandscape ? CGSize(width: 1920, height: 1080) : CGSize(width: 1082, height: 1920)
        
        let xMultiplier = imageSize.width / screenSize.width
        let yMultiplier = imageSize.height / screenSize.height
        
        let convertedRect = CGRect(x: targetRect.origin.x * xMultiplier,
                                   y: (targetRect.origin.y + (targetRect.size.height / 3 * 2)) * yMultiplier,
                                   width: targetRect.size.width * xMultiplier,
                                   height: targetRect.size.height / 3 * yMultiplier)
        mrzRect = convertedRect
    }
    
    private func updateVideoOrientation() {
        cameraSession.videoOrientation = videoOrientationFromInterfaceOrientation()
    }
    
    @IBAction private func selectImageButtonDidPress(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    private func show(result: SBSDKMachineReadableZoneRecognizerResult?) {
        let resultMessage = result?.stringRepresentation() ?? "Nothing detected"
        let alert = UIAlertController(title: "Result",
                                      message: resultMessage,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK",
                                   style: .default) { [weak self] action in
            if self?.imageView?.image != nil {
                self?.imageView?.image = nil
                self?.blackView?.isHidden = true
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension MRZDemoViewController: SBSDKCameraSessionDelegate {
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        var shouldRecognize = false
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            shouldRecognize = self.shouldRecognize()
        }
        if shouldRecognize {
            if let result = recognizer.recognizePersonalIdentity(from: sampleBuffer,
                                                                 orientation: cameraSession.videoOrientation,
                                                                 machineReadableZoneRect: mrzRect),
               result.recognitionSuccessful {
                DispatchQueue.main.async { [weak self] in
                    self?.show(result: result)
                }
            }
        }
    }
}

extension MRZDemoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView?.image = image
            dismiss(animated: true) { [weak self] in
                self?.show(result: self?.recognizer.recognizePersonalIdentity(from: image))
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
