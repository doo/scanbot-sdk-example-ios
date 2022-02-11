//
//  WorkflowFactory.swift
//  ReadyToUseUIDemo
//
//  Created by Danil Voitenko on 05.01.22.
//  Copyright © 2022 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

enum WorkflowError: Error {
    case backSideRecognitionFailed
    case notIDCard
    case noPayformData
    
    var description: String {
        switch self {
        case .backSideRecognitionFailed: return "This does not seem to be the correct side. Please scan the side containing MRZ lines."
        case .notIDCard: return "This does not seem to be an ID card."
        case .noPayformData: return "No payform data detected."
        }
    }
}

class WorkflowFactory {
    
    static func allWorkflows() -> [SBSDKUIWorkflow] {
        return [idCard(), idCardOrPassport(), payform(), qrCodeAndDocument()]
    }
    
    static func idCard() -> SBSDKUIWorkflow {
        let ratios = [SBSDKAspectRatio(width: 85, andHeight: 54)]
        let frontSide = SBSDKUIWorkflowStep(title: "Step 1 of 2",
                                            message: "Please scan the front of your ID card",
                                            requiredAspectRatios: ratios,
                                            wantsCapturedPage: true,
                                            wantsVideoFramePage: false,
                                            acceptedMachineReadableCodeTypes: nil,
                                            resultValidation: nil)
        let backSide = SBSDKUIScanMachineReadableZoneWorkflowStep(title: "Step 2 of 2",
                                                                  message: "Please scan the back of your ID card",
                                                                  requiredAspectRatios: ratios,
                                                                  wantsCapturedPage: true) { result in
            guard let mrz = result.mrzResult, mrz.recognitionSuccessful else {
                return WorkflowError.backSideRecognitionFailed
            }
            guard mrz.documentType == SBSDKMachineReadableZoneRecognizerResultDocumentType.idCard else {
                return WorkflowError.notIDCard
            }
            return nil
        }
        
        return SBSDKUIWorkflow(steps: [frontSide, backSide],
                               name: "ID Card - Front + Back Image + MRZ",
                               validationHandler: nil)!
    }
    
    static func idCardOrPassport() -> SBSDKUIWorkflow {
        let ratios = [SBSDKAspectRatio(width: 85, andHeight: 54),  // ID Card
                      SBSDKAspectRatio(width: 125, andHeight: 88)] // Passport
        
        let step = SBSDKUIScanMachineReadableZoneWorkflowStep(title: "Scan ID card or passport",
                                                                  message: "Please align your ID card or passport in the frame.",
                                                                  requiredAspectRatios: ratios,
                                                                  wantsCapturedPage: true) { result in
            guard let mrz = result.mrzResult, mrz.recognitionSuccessful else {
                return WorkflowError.backSideRecognitionFailed
            }
            return nil
        }
        
        return SBSDKUIWorkflow(steps: [step],
                               name: "ID Card or Passport - Image + MRZ",
                               validationHandler: nil)!
    }
    
    static func payform() -> SBSDKUIWorkflow {
        let payform = SBSDKUIScanPayFormWorkflowStep(title: "Please scan a SEPA payform",
                                                     message: "",
                                                     wantsCapturedPage: false) { result in
            guard let payform = result.payformResult, !payform.recognizedFields.isEmpty else {
                return WorkflowError.noPayformData
            }
            return nil
        }
        return SBSDKUIWorkflow(steps: [payform],
                               name: "SEPA Payform",
                               validationHandler: nil)!
    }
        
    static func qrCodeAndDocument() -> SBSDKUIWorkflow {
        
        let qrCodeStep = SBSDKUIScanBarCodeWorkflowStep(title: "Step 1 of 2",
                                                        message: "Please scan a QR code",
                                                        acceptedCodeTypes: [SBSDKBarcodeTypeQRCode],
                                                        finderViewAspectRatio: SBSDKAspectRatio(width: 1, andHeight: 1),
                                                        resultValidation: nil)
        
        let ratios = [SBSDKAspectRatio(width: 210, andHeight: 297), // A4 sheet portrait
                      SBSDKAspectRatio(width: 297, andHeight: 210)] // A4 sheet landscape
        
        let documentStep = SBSDKUIScanDocumentPageWorkflowStep(title: "Step 2 of 2",
                                                               message: "Please scan an A4 document.",
                                                               requiredAspectRatios: ratios) { page in
            page.filter = SBSDKImageFilterTypeBlackAndWhite
        }
        
        return SBSDKUIWorkflow(steps: [qrCodeStep,documentStep],
                               name: "QR Code and Document",
                               validationHandler: nil)!
    }
}
