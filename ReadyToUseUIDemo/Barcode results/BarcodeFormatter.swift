//
//  BarcodeFormatter.swift
//  SBBarcodeSDKDemo
//
//  Created by Yevgeniy Knizhnik on 02.12.19.
//  Copyright © 2019 doo GmbH. All rights reserved.
//

import Foundation
import ScanbotSDK

class BarcodeFormatter {
    func formattedBarcodeText(barcode: SBSDKBarcodeScannerResult) -> String? {
        if let formattedResult = barcode.formattedResult as? SBSDKAAMVADocumentFormat {
            return self.formattedAAMVADocument(formattedResult)
        } else if let formattedResult = barcode.formattedResult as? SBSDKIDCardPDF417DocumentFormat {
            return self.formattedPDF417IDCardDocument(formattedResult)
        } else if let formattedResult = barcode.formattedResult as? SBSDKBoardingPassDocumentFormat {
            return self.formattedBoardingPassDocument(formattedResult)
        } else if let formattedResult = barcode.formattedResult as? SBSDKMedicalCertificateDocumentFormat {
            return self.formattedDCDocument(formattedResult)
        } else if let formattedResult = barcode.formattedResult as? SBSDKSEPADocumentFormat {
            return self.formattedSepaDocument(formattedResult)
        } else if let formattedResult = barcode.formattedResult as? SBSDKMedicalPlanDocumentFormat {
            return self.formattedMedicalPlan(formattedResult)
        } else if let formattedResult = barcode.formattedResult as? SBSDKVCardDocumentFormat {
            return self.formattedVCard(formattedResult)
        }
        return nil
    }
    
    func formattedMedicalPlan(_ plan: SBSDKMedicalPlanDocumentFormat) -> String {
        var result = "\n\n\nDetected German medical plan document:\n"
        result = result + "\nGUID: \(plan.guid)"
        result = result + "\nCurrent page: \(plan.currentPage)"
        result = result + "\nTotal number of pages: \(plan.totalNumberOfPages)"
        result = result + "\nDocument version: \(plan.documentVersionNumber)"
        result = result + "\nPatch version: \(plan.patchVersionNumber)"
        result = result + "\nLanguage code: \(plan.languageCountryCode)"
        
        result = result + "\n\nPatient information:"
        for field in plan.patient.fields {
            result = result + "\n\(field.typeHumanReadableString): \(field.value)"
        }
        
        result = result + "\n\nDoctor information:"
        for field in plan.doctor.fields {
            result = result + "\n\(field.typeHumanReadableString): \(field.value ?? "-")"
        }

        if plan.subheadings.count > 0 {
            result = result + "\n\nSubheadings:"
            for subheading in plan.subheadings {
                for field in subheading.fields {
                    result = result + "\n\(field.typeHumanReadableString): \(field.value)"
                }
                
                if (subheading.generalNotes.count > 0) {
                    result = result + "\nGeneral notes:"
                    for note in subheading.generalNotes {
                        result = result + "\n\(note)\n"
                    }
                }
                
                if subheading.prescriptions.count > 0 {
                    result = result + "\nPrescriptions:"
                    for prescription in subheading.prescriptions {
                        for prescriptionField in prescription.fields {
                            result = result + "\n\(prescriptionField.typeHumanReadableString): \(prescriptionField.value)"
                        }
                        result = result + "\n------"
                    }
                }
                
                if subheading.medicines.count > 0 {
                    result = result + "\nMedicines:"
                    for medicine in subheading.medicines {
                        for medicineField in medicine.fields {
                            result = result + "\n\(medicineField.typeHumanReadableString): \(medicineField.value)"
                        }
                        
                        if (medicine.substances.count > 0) {
                            for substance in medicine.substances {
                                for substanceField in substance.fields {
                                    result = result + "\n\(substanceField.typeHumanReadableString): \(substanceField.value)"
                                }
                            }
                        }
                        
                        result = result + "\n------"
                    }
                }
                
                result = result + "\n\n"
            }
        }
        
        return result
    }
    
    func formattedVCard(_ card: SBSDKVCardDocumentFormat) -> String {
        var result = "\n\n\nDetected vCard document:"
        
        if card.fields.count > 0 {
            result = result + "\n\nFields:"
            for field in card.fields {
                var value = field.values[0]
                if field.values.count > 1 {
                    value = "\(value)..."
                }
                
                result = result + "\n\(field.typeHumanReadableString): \(value)"
            }
        }

        return result
    }
    
    func formattedAAMVADocument(_ document: SBSDKAAMVADocumentFormat) -> String {
        var result = "\n\n\nDetected AAMVA document:\n\nRaw header string: \(document.headerRawString)"
        result = result + "\nFile type: \(document.fileType)"
        result = result + "\nIssuer ID number: \(document.issuerIdentificationNumber)"
        result = result + "\nAAMVA version: \(document.AAMVAVersionNumber)"
        result = result + "\nJurisdiction version: \(document.jurisdictionVersionNumber)"
        
        if document.subfiles.count > 0 {
            result = result + "\n\nSubfiles:"
            for subFile in document.subfiles {
                result = result + "\nSubfile type: \(subFile.subFileType)"
                
                for field in subFile.fields {
                    result = result + "\n\(field.typeHumanReadableString): \(field.value)"
                }
                result = result + "\n\n"
            }
        }
        
        return result
    }
    
    
    func formattedPDF417IDCardDocument(_ document: SBSDKIDCardPDF417DocumentFormat) -> String {
        var result = "\n\n\nDetected PDF417 ID card:\n\n"
        if document.fields.count > 0 {
            for field in document.fields {
                result = result + "\n\(field.typeHumanReadableString): \(field.value)"
            }
        }
        
        return result
    }
    
    func formattedBoardingPassDocument(_ document: SBSDKBoardingPassDocumentFormat) -> String {
        var result = "\n\n\nDetected boarding pass:\n"
        result = result + "\nName: \(document.name)"
        result = result + "\nSecurity data: \(document.securityData)"
        result = result + "\nElectronic:\(document.electronicTicket)i"
        
        if document.legs.count > 0 {
            result = result + "\n\nLegs:"
            for leg in document.legs {
                result = result + "\n\n-----------"
                for field in leg.fields {
                    result = result + "\n\(field.typeHumanReadableString): \(field.value)"
                }
            }
        }
        
        return result
    }
    func formattedDCDocument(_ document: SBSDKMedicalCertificateDocumentFormat) -> String {
        var result = "\n\n\nDetected DC form bar code:\n"
        if document.fields.count > 0 {
            for field in document.fields {
                result = result + "\n\(field.typeHumanReadableString): \(field.value)"
            }
        }
        
        return result
    }
    
    func formattedSepaDocument(_ document: SBSDKSEPADocumentFormat) -> String {
        var result = "\n\n\nDetected SEPA form bar code:\n"
        if document.fields.count > 0 {
            for field in document.fields {
                result = result + "\n\(field.typeHumanReadableString): \(field.value)"
            }
        }
        
        return result
    }
}
