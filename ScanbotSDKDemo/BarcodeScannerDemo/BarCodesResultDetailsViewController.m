//
//  BarCodesResultDetailsViewController.m
//  ScanbotSDK Demo
//
//  Created by Andrew Petrus on 13.05.19.
//  Copyright © 2019 doo GmbH. All rights reserved.
//

#import "BarCodesResultDetailsViewController.h"

@interface BarCodesResultDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *barCodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *barCodeTextLabel;

@end

@implementation BarCodesResultDetailsViewController

- (NSString *)hexStringFromData:(NSData *)data {
    NSUInteger len = [data length];
    char *chars = (char *)[data bytes];
    NSMutableString *hexString = [[NSMutableString alloc] init];

    for (NSUInteger i = 0; i < len; i++) {
        [hexString appendString:[NSString stringWithFormat:@"%0.2hhx", chars[i]]];
    }

    return hexString;
}

#pragma mark - German medical plan documents

- (NSString *)medicalPlanDocumentFormatToString:(SBSDKMedicalPlanDocumentFormat *)medicalPlanDocumentFormat {
    NSString *result = @"\n\n\nDetected German medical plan document:\n";
    result = [result stringByAppendingFormat:@"\nGUID: %@", medicalPlanDocumentFormat.GUID];
    result = [result stringByAppendingFormat:@"\nCurrent page: %li", (long)medicalPlanDocumentFormat.currentPage];
    result = [result stringByAppendingFormat:@"\nTotal number of pages: %li", (long)medicalPlanDocumentFormat.totalNumberOfPages];
    result = [result stringByAppendingFormat:@"\nDocument version: %@", medicalPlanDocumentFormat.documentVersionNumber];
    result = [result stringByAppendingFormat:@"\nPatch version: %@", medicalPlanDocumentFormat.patchVersionNumber];
    result = [result stringByAppendingFormat:@"\nLanguage code: %@", medicalPlanDocumentFormat.languageCountryCode];
    
    result = [result stringByAppendingString:@"\n\nPatient information:"];
    for (SBSDKMedicalPlanPatientField *field in medicalPlanDocumentFormat.patient.fields) {
        result = [result stringByAppendingFormat:@"\n%@: %@", field.typeHumanReadableString, field.value];
    }
    
    result = [result stringByAppendingString:@"\n\nDoctor information:"];
    for (SBSDKMedicalPlanDoctorField *field in medicalPlanDocumentFormat.doctor.fields) {
        result = [result stringByAppendingFormat:@"\n%@: %@", field.typeHumanReadableString, field.value];
    }

    if (medicalPlanDocumentFormat.subheadings.count > 0) {
        result = [result stringByAppendingString:@"\n\nSubheadings:"];
        for (SBSDKMedicalPlanStandardSubheading *subheading in medicalPlanDocumentFormat.subheadings) {
            for (SBSDKMedicalPlanStandardSubheadingField *field in subheading.fields) {
                result = [result stringByAppendingFormat:@"\n%@: %@", field.typeHumanReadableString, field.value];
            }
            
            if (subheading.generalNotes.count > 0) {
                result = [result stringByAppendingString:@"\nGeneral notes:"];
                for (NSString *note in subheading.generalNotes) {
                    result = [result stringByAppendingFormat:@"\n%@\n", note];
                }
            }
            
            if (subheading.prescriptions.count > 0) {
                result = [result stringByAppendingString:@"\nReceipes:"];
                for (SBSDKMedicalPlanSubheadingPrescription *prescription in subheading.prescriptions) {
                    for (SBSDKMedicalPlanSubheadingPrescriptionField *prescriptionField in prescription.fields) {
                        result = [result stringByAppendingFormat:@"\n%@: %@", prescriptionField.typeHumanReadableString, prescriptionField.value];
                    }
                    result = [result stringByAppendingString:@"\n------"];
                }
            }
            
            if (subheading.medicines.count > 0) {
                result = [result stringByAppendingString:@"\nMedicines:"];
                for (SBSDKMedicalPlanMedicine *medicine in subheading.medicines) {
                    for (SBSDKMedicalPlanSubheadingPrescriptionField *medicineField in medicine.fields) {
                        result = [result stringByAppendingFormat:@"\n%@: %@", medicineField.typeHumanReadableString, medicineField.value];
                    }
                    
                    if (medicine.substances.count > 0) {
                        for (SBSDKMedicalPlanMedicineSubstance *substance in medicine.substances) {
                            for (SBSDKMedicalPlanMedicineSubstanceField *substanceField in substance.fields) {
                                result = [result stringByAppendingFormat:@"\n%@: %@", substanceField.typeHumanReadableString, substanceField.value];
                            }
                        }
                    }
                    
                    result = [result stringByAppendingString:@"\n------"];
                }
            }
            
            result = [result stringByAppendingString:@"\n\n"];
        }
    }
    
    return result;
}

#pragma mark - vCard documents

- (NSString *)vCardDocumentFormatToString:(SBSDKVCardDocumentFormat *)vCardDocumentFormat {
    NSString *result = @"\n\n\nDetected vCard document:";
    
    if (vCardDocumentFormat.fields.count > 0) {
        result = [result stringByAppendingString:@"\n\nFields:"];
        for (SBSDKVCardDocumentField *field in vCardDocumentFormat.fields) {
            NSString *value = field.values[0];
            if (field.values.count > 1) {
                value = [NSString stringWithFormat:@"%@...", value];
            }
            
            result = [result stringByAppendingFormat:@"\n%@: %@", field.typeHumanReadableString, value];
        }
    }

    return result;
}


#pragma mark - AAMVA documents

- (NSString *)AAMVADocumentFormatToString:(SBSDKAAMVADocumentFormat *)aamvaDocumentFormat {
    NSString *result = [NSString stringWithFormat:@"\n\n\nDetected AAMVA document:\n\nRaw header string: %@", aamvaDocumentFormat.headerRawString];
    result = [result stringByAppendingFormat:@"\nFile type: %@", aamvaDocumentFormat.fileType];
    result = [result stringByAppendingFormat:@"\nIssuer ID number: %@", aamvaDocumentFormat.issuerIdentificationNumber];
    result = [result stringByAppendingFormat:@"\nAAMVA version: %@", aamvaDocumentFormat.AAMVAVersionNumber];
    result = [result stringByAppendingFormat:@"\nJurisdiction version: %@", aamvaDocumentFormat.jurisdictionVersionNumber];
    
    if (aamvaDocumentFormat.subfiles.count > 0) {
        result = [result stringByAppendingString:@"\n\nSubfiles:"];
        for (SBSDKAAMVADocumentSubfile *subFile in aamvaDocumentFormat.subfiles) {
            result = [result stringByAppendingFormat:@"\nSubfile type: %@", subFile.subFileType];
            
            for (SBSDKAAMVADocumentSubfileField *field in subFile.fields) {
                result = [result stringByAppendingFormat:@"\n%@: %@", field.typeHumanReadableString, field.value];
            }
            result = [result stringByAppendingString:@"\n\n"];
        }
    }
    
    return result;
}

#pragma mark - PDF417 ID cards

- (NSString *)PDF417IDCardDocumentFormatToString:(SBSDKIDCardPDF417DocumentFormat *)pdf417DocumentFormat {
    NSString *result = @"\n\n\nDetected PDF417 ID card:\n\n";
    if (pdf417DocumentFormat.fields.count > 0) {
        for (SBSDKIDCardPDF417DocumentField *field in pdf417DocumentFormat.fields) {
            result = [result stringByAppendingFormat:@"\n%@: %@", field.typeHumanReadableString, field.value];
        }
    }
    
    return result;
}

#pragma mark - Boarding pass bar codes

- (NSString *)BoardingPassDocumentFormatToString:(SBSDKBoardingPassDocumentFormat *)boardingPassDocumentFormat {
    NSString *result = @"\n\n\nDetected boarding pass:\n";
    result = [result stringByAppendingFormat:@"\nName: %@", boardingPassDocumentFormat.name];
    result = [result stringByAppendingFormat:@"\nSecurity data: %@", boardingPassDocumentFormat.securityData];
    result = [result stringByAppendingFormat:@"\nElectronic: %i", boardingPassDocumentFormat.electronicTicket];
    
    if (boardingPassDocumentFormat.legs.count > 0) {
        result = [result stringByAppendingString:@"\n\nLegs:"];
        for (SBSDKBoardingPassLeg *leg in boardingPassDocumentFormat.legs) {
            result = [result stringByAppendingString:@"\n\n-----------"];
            for (SBSDKBoardingPassLegField *field in leg.fields) {
                result = [result stringByAppendingFormat:@"\n%@: %@", field.typeHumanReadableString, field.value];
            }
        }
    }
    
    return result;
}

#pragma mark - Disability certificate bar codes

- (NSString *)DCDocumentFormatToString:(SBSDKDisabilityCertificateDocumentFormat *)dcDocumentFormat {
    NSString *result = @"\n\n\nDetected DC form bar code:\n";
    if (dcDocumentFormat.fields.count > 0) {
        for (SBSDKDisabilityCertificateDocumentField *field in dcDocumentFormat.fields) {
            result = [result stringByAppendingFormat:@"\n%@: %@", field.typeHumanReadableString, field.value];
        }
    }
    
    return result;
}

#pragma mark - SEPA form bar codes

- (NSString *)SEPADocumentFormatToString:(SBSDKSEPADocumentFormat *)sepaDocumentFormat {
    NSString *result = @"\n\n\nDetected SEPA form bar code:\n";
    if (sepaDocumentFormat.fields.count > 0) {
        for (SBSDKSEPADocumentField *field in sepaDocumentFormat.fields) {
            result = [result stringByAppendingFormat:@"\n%@: %@", field.typeHumanReadableString, field.value];
        }
    }
    
    return result;
}

#pragma mark - UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 600;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.barcodeFormat) {
        if ([self.barcodeFormat isKindOfClass:[SBSDKAAMVADocumentFormat class]]) {
            self.barCodeText = [self.barCodeText stringByAppendingString:[self AAMVADocumentFormatToString:(SBSDKAAMVADocumentFormat *)self.barcodeFormat]];
        } else if ([self.barcodeFormat isKindOfClass:[SBSDKIDCardPDF417DocumentFormat class]]) {
            self.barCodeText = [self.barCodeText stringByAppendingString:[self PDF417IDCardDocumentFormatToString:(SBSDKIDCardPDF417DocumentFormat *)self.barcodeFormat]];
        } else if ([self.barcodeFormat isKindOfClass:[SBSDKBoardingPassDocumentFormat class]]) {
            self.barCodeText = [self.barCodeText stringByAppendingString:[self BoardingPassDocumentFormatToString:(SBSDKBoardingPassDocumentFormat *)self.barcodeFormat]];
        } else if ([self.barcodeFormat isKindOfClass:[SBSDKDisabilityCertificateDocumentFormat class]]) {
            self.barCodeText = [self.barCodeText stringByAppendingString:[self DCDocumentFormatToString:(SBSDKDisabilityCertificateDocumentFormat *)self.barcodeFormat]];
        } else if ([self.barcodeFormat isKindOfClass:[SBSDKSEPADocumentFormat class]]) {
            self.barCodeText = [self.barCodeText stringByAppendingString:[self SEPADocumentFormatToString:(SBSDKSEPADocumentFormat *)self.barcodeFormat]];
        } else if ([self.barcodeFormat isKindOfClass:[SBSDKMedicalPlanDocumentFormat class]]) {
            self.barCodeText = [self.barCodeText stringByAppendingString:[self medicalPlanDocumentFormatToString:(SBSDKMedicalPlanDocumentFormat *)self.barcodeFormat]];
        } else if ([self.barcodeFormat isKindOfClass:[SBSDKVCardDocumentFormat class]]) {
            self.barCodeText = [self.barCodeText stringByAppendingString:[self vCardDocumentFormatToString:(SBSDKVCardDocumentFormat *)self.barcodeFormat]];
        }
    }
    
    if (self.barCodeImage) {
        self.barCodeImageView.image = self.barCodeImage;
    }
    
    if (self.barCodeText) {
        self.barCodeTextLabel.text = self.barCodeText;
        if (self.barCodeRawBytes) {
            self.barCodeTextLabel.text = [self.barCodeTextLabel.text stringByAppendingFormat:@"\n\nRaw bytes:\n%@", [self hexStringFromData:self.barCodeRawBytes]];
        }
    } else {
        self.barCodeTextLabel.text = @"";
    }
}

@end
