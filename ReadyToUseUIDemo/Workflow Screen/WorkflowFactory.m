//
//  WorkflowFactory.m
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 20.11.18.
//  Copyright © 2019 doo GmbH. All rights reserved.
//

#import "WorkflowFactory.h"

@interface WorkflowError: NSObject

+ (NSError *)errorWithCode:(NSInteger)errorCode localizedDescription:(NSString *)description;

@end


@implementation WorkflowError

+ (NSError *)errorWithCode:(NSInteger)errorCode localizedDescription:(NSString *)description {
    NSDictionary *userInfo = nil;
    if (description != nil) {
        userInfo = [NSDictionary dictionaryWithObject:description forKey:NSLocalizedDescriptionKey];
    }
    return [NSError errorWithDomain:@"WorkflowErrorDomain" code:errorCode userInfo:userInfo];
}


@end

@implementation WorkflowFactory

+ (NSArray<SBSDKUIWorkflow*>*)allWorkflows {
    return @[[self idCard],
             [self idCardOrPassport],
             [self disabilityCertificate],
             [self qrCodeAndDocument],
             [self payform]];
}

+ (SBSDKUIWorkflow *)idCard {

    NSArray *ratios = @[[[SBSDKPageAspectRatio alloc] initWithWidth:85.0 andHeight:54.0]];

    SBSDKUIWorkflowStep *frontSide
    = [[SBSDKUIWorkflowStep alloc] initWithTitle:@"Step 1 of 2"
                                         message:@"Please scan the front of your ID card."
                            requiredAspectRatios:ratios
                               wantsCapturedPage:YES
                             wantsVideoFramePage:NO
                acceptedMachineReadableCodeTypes:nil
                                resultValidation:^NSError *(SBSDKUIWorkflowStepResult *result) {
                                    return nil;
                                }];

    SBSDKUIWorkflowStep *backSide
    = [[SBSDKUIScanMachineReadableZoneWorkflowStep alloc] initWithTitle:@"Step 2 of 2"
                                                                message:@"Please scan the back of your ID card."
                                                   requiredAspectRatios:ratios
                                                      wantsCapturedPage:YES
                                                       resultValidation:^NSError *(SBSDKUIWorkflowStepResult *result) {
                                                           SBSDKMachineReadableZoneRecognizerResult *mrz = result.mrzResult;
                                                           if (mrz == nil || !mrz.recognitionSuccessfull) {
                                                               return [WorkflowError errorWithCode:2
                                                                              localizedDescription: @"This does not seem to be the back side."];
                                                           }

                                                           if (mrz.documentType != SBSDKMachineReadableZoneRecognizerResultDocumentTypeIDCard) {
                                                               return [WorkflowError errorWithCode:3
                                                                              localizedDescription: @"This does not seem to be an ID card."];
                                                           }
                                                           
                                                           /*
                                                           // Example for validating the issuing state from parsed MRZ data fields:
                                                           if (mrz.documentCodeField.value.length != 9
                                                               || ![mrz.issuingStateOrOrganizationField.value isEqualToString:@"D"] ) {
                                                               return [WorkflowError errorWithCode:3
                                                                              localizedDescription: @"This does not seem to be a german ID card."];
                                                           }
                                                           */
                                                           
                                                           return nil;
                                                       }];

    SBSDKUIWorkflow *workflow = [[SBSDKUIWorkflow alloc] initWithSteps:@[frontSide, backSide]
                                                                  name:@"ID Card - Front + Back Image + MRZ"
                                                     validationHandler:nil];

    return workflow;
}

+ (SBSDKUIWorkflow *)idCardOrPassport {

    NSArray *ratios = @[[[SBSDKPageAspectRatio alloc] initWithWidth:85.0 andHeight:54.0],   // ID card
                        [[SBSDKPageAspectRatio alloc] initWithWidth:125.0 andHeight:88.0]]; // Passport

    SBSDKUIWorkflowStep *step
    = [[SBSDKUIScanMachineReadableZoneWorkflowStep alloc] initWithTitle:@"Scan ID card or passport"
                                                                message:@"Please align your ID card or passport in the frame."
                                                   requiredAspectRatios:ratios
                                                      wantsCapturedPage:YES
                                                       resultValidation:^NSError *(SBSDKUIWorkflowStepResult *result) {
                                                            // Example of custom detection in result validation step:
                                                            SBSDKMachineReadableZoneRecognizer *recognizer = [[SBSDKMachineReadableZoneRecognizer alloc] init];
                                                            SBSDKMachineReadableZoneRecognizerResult *mrz = [recognizer recognizePersonalIdentityFromImage:result.capturedPage.documentImage];

                                                            if (mrz == nil || !mrz.recognitionSuccessfull) {
                                                                return [WorkflowError errorWithCode:2
                                                                               localizedDescription: @"This does not seem to be the correct side. Please scan the side containing MRZ lines."];
                                                            }
                                                           
                                                            /*
                                                            // Example for validating the document type from parsed MRZ data fields:
                                                            if (mrz.documentType != SBSDKMachineReadableZoneRecognizerResultDocumentTypePassport) {
                                                                return [WorkflowError errorWithCode:3
                                                                               localizedDescription: @"This does not seem to be a passport."];
                                                            }
                                                            */
                                                           
                                                            return nil;
                                                       }];
    
    SBSDKUIWorkflow *workflow = [[SBSDKUIWorkflow alloc] initWithSteps:@[step]
                                                                  name:@"ID Card or Passport - Image + MRZ"
                                                     validationHandler:nil];

    return workflow;
}

+ (SBSDKUIWorkflow *)payform {
    SBSDKUIWorkflowStep *payform = [[SBSDKUIScanPayFormWorkflowStep alloc] initWithTitle:@"Please scan a SEPA payform"
                                                                                 message:@""
                                                                       wantsCapturedPage:NO
                                                                        resultValidation:^NSError *(SBSDKUIWorkflowStepResult *result) {
                                                                            SBSDKPayFormRecognitionResult *payform = result.payformResult;
                                                                            if (payform == nil || payform.recognizedFields.count == 0) {
                                                                                return [WorkflowError errorWithCode:3 localizedDescription:@"No payform data detected."];
                                                                            }
                                                                            return nil;
                                                                       }];

    SBSDKUIWorkflow *workflow = [[SBSDKUIWorkflow alloc] initWithSteps:@[payform]
                                                                  name:@"SEPA Payform"
                                                     validationHandler:nil];
    
    return workflow;
}


+ (SBSDKUIWorkflow *)disabilityCertificate {

    NSArray *ratios = @[[[SBSDKPageAspectRatio alloc] initWithWidth:148.0 andHeight:210.0],  // DC form A5 portrait (e.g. white sheet, AUB Muster 1b/E (1/2018))
                        [[SBSDKPageAspectRatio alloc] initWithWidth:148.0 andHeight:105.0]]; // DC form A6 landscape (e.g. yellow sheet, AUB Muster 1b (1.2018))
                        
    SBSDKUIWorkflowStep *step
    = [[SBSDKUIScanDisabilityCertificateWorkflowStep alloc] initWithTitle:@"Please align the DC form in the frame."
                                                                  message:@""
                                                     requiredAspectRatios:ratios
                                                        wantsCapturedPage:YES
                                                         resultValidation:^NSError *(SBSDKUIWorkflowStepResult * result) {
                                                             SBSDKDisabilityCertificatesRecognizerResult *dc = result.disabilityCertificateResult;
                                                             if (dc == nil || !dc.recognitionSuccessful) {
                                                                 return [WorkflowError errorWithCode:2
                                                                                localizedDescription: @"This does not seem to be a valid certificate."];
                                                             }
                                                             return nil;
                                                         }];
    
    
    SBSDKUIWorkflow *workflow = [[SBSDKUIWorkflow alloc] initWithSteps:@[step]
                                                                  name:@"Disability Certificate"
                                                     validationHandler:nil];

    return workflow;
}


+ (SBSDKUIWorkflow *)qrCodeAndDocument {
    
    SBSDKUIWorkflowStep *qrcodeStep
    = [[SBSDKUIScanBarCodeWorkflowStep alloc] initWithTitle:@"Step 1 of 2"
                                                    message:@"Please scan a QR code."
                                          acceptedCodeTypes:@[AVMetadataObjectTypeQRCode]
                                             finderViewSize:CGSizeMake(1, 1)
                                           resultValidation:nil];

    NSArray *ratios = @[[[SBSDKPageAspectRatio alloc] initWithWidth:210.0 andHeight:297.0],  // A4 sheet portrait
                        [[SBSDKPageAspectRatio alloc] initWithWidth:297.0 andHeight:210.0]]; // A4 sheet landscape

    SBSDKUIWorkflowStep *documentStep
    = [[SBSDKUIScanDocumentPageWorkflowStep alloc] initWithTitle:@"Step 2 of 2"
                                                         message:@"Please scan an A4 document."
                                            requiredAspectRatios:ratios
                                              pagePostProcessing:^(SBSDKUIPage *page) {
                                                  [page setFilter:SBSDKImageFilterTypeBlackAndWhite];
                                              }
                                                resultValidation:nil];

    SBSDKUIWorkflow *workflow = [[SBSDKUIWorkflow alloc] initWithSteps:@[qrcodeStep, documentStep]
                                                                  name:@"QR Code and Document"
                                                     validationHandler:nil];
    
    return workflow;
}

@end
