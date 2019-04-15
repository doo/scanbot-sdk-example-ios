//
//  WorkflowFactory.m
//  SBSDK Internal Demo
//
//  Created by Sebastian Husche on 20.11.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
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
    return @[[self germanIDCard],
             [self ukrainianPassport],
             [self payform],
             [self disabilityCertificate],
             [self qrCodeAndDocument],
             [self blackWhiteDocument]];
}

+ (SBSDKUIWorkflow *)germanIDCard {

    NSArray *ratios = @[[[SBSDKPageAspectRatio alloc] initWithWidth:1.0 andHeight:0.6353]];

    SBSDKUIWorkflowStep *frontSide
    = [[SBSDKUIScanMachineReadableZoneWorkflowStep alloc] initWithTitle:@"German ID card 1/2"
                                                                message:@"Please scan the front of your id card."
                                                   requiredAspectRatios:ratios
                                                      wantsCapturedPage:YES
                                                       resultValidation:^NSError *(SBSDKUIWorkflowStepResult *result) {
                                                           SBSDKMachineReadableZoneRecognizerResult *mrz
                                                           = result.mrzResult;
                                                           if (mrz.recognitionSuccessfull) {
                                                               return [WorkflowError errorWithCode:1
                                                                              localizedDescription: @"This does not seem to be the front side."];
                                                           }
                                                           return nil;
                                                       }];

    SBSDKUIWorkflowStep *backSide
    = [[SBSDKUIScanMachineReadableZoneWorkflowStep alloc] initWithTitle:@"German ID card 2/2"
                                                                message:@"Please scan the back of your id card."
                                                   requiredAspectRatios:ratios
                                                      wantsCapturedPage:YES
                                                       resultValidation:^NSError *(SBSDKUIWorkflowStepResult *result) {
                                                           SBSDKMachineReadableZoneRecognizerResult *mrz
                                                           = result.mrzResult;
                                                           if (mrz == nil || !mrz.recognitionSuccessfull) {
                                                               return [WorkflowError errorWithCode:2
                                                                              localizedDescription: @"This does not seem to be the back side."];
                                                           }

                                                           if (mrz.documentType != SBSDKMachineReadableZoneRecognizerResultDocumentTypeIDCard) {
                                                               return [WorkflowError errorWithCode:3
                                                                              localizedDescription: @"This does not seem to be an ID card."];
                                                           }
                                                           
                                                           if (mrz.documentCodeField.value.length != 9
                                                               || ![mrz.issuingStateOrOrganizationField.value isEqualToString:@"D"] ) {
                                                               
                                                               return [WorkflowError errorWithCode:3
                                                                              localizedDescription: @"This does not seem to be a german ID card."];
                                                           }
                                                           
                                                           return nil;
                                                       }];

    SBSDKUIWorkflow *workflow = [[SBSDKUIWorkflow alloc] initWithSteps:@[frontSide, backSide]
                                                                  name:@"German ID card"
                                                     validationHandler:nil];

    return workflow;
}

+ (SBSDKUIWorkflow *)ukrainianPassport {

    NSArray *ratios = nil;//@[@(0.704)];

    SBSDKUIWorkflowStep *frontSide
    = [[SBSDKUIWorkflowStep alloc] initWithTitle:@"Ukrainian passport 1/1"
                                         message:@"Please scan the front of your passport card."
                            requiredAspectRatios:ratios
                               wantsCapturedPage:YES
                             wantsVideoFramePage:NO
                acceptedMachineReadableCodeTypes:nil
                                resultValidation:^NSError *(SBSDKUIWorkflowStepResult *result) {
                                    
                                    //Demonstrates custom detection in result validation step
                                    SBSDKMachineReadableZoneRecognizer *recognizer = [[SBSDKMachineReadableZoneRecognizer alloc] init];
                                    SBSDKMachineReadableZoneRecognizerResult *mrz = [recognizer recognizePersonalIdentityFromImage:result.capturedPage.documentImage];

                                    if (mrz == nil || !mrz.recognitionSuccessfull) {
                                        return [WorkflowError errorWithCode:2
                                                       localizedDescription: @"This does not seem to be the correct page."];
                                    }
                                    
                                    if (mrz.documentType != SBSDKMachineReadableZoneRecognizerResultDocumentTypePassport) {
                                        return [WorkflowError errorWithCode:3
                                                       localizedDescription: @"This does not seem to be an passport."];
                                    }
                                    
                                    if (mrz.documentCodeField.value.length != 8
                                        || ![mrz.issuingStateOrOrganizationField.value isEqualToString:@"UKR"] ) {
                                        
                                        return [WorkflowError errorWithCode:3
                                                       localizedDescription: @"This does not seem to be a ukrainian passport."];
                                    }
                                    
                                    return nil;
                                }];
    
    SBSDKUIWorkflow *workflow = [[SBSDKUIWorkflow alloc] initWithSteps:@[frontSide]
                                                                  name:@"Ukrainian passport"
                                                     validationHandler:nil];

    return workflow;
}

+ (SBSDKUIWorkflow *)payform {
    SBSDKUIWorkflowStep *payform = [[SBSDKUIScanPayFormWorkflowStep alloc] initWithTitle:@"Payform 1/1"
                                                                                 message:@"Please scan your SEPA payform."
                                                                       wantsCapturedPage:NO
                                                                        resultValidation:^NSError *(SBSDKUIWorkflowStepResult *result) {
                                                                            SBSDKPayFormRecognitionResult *payform = result.payformResult;
                                                                            if (payform == nil || payform.recognizedFields.count == 0) {
                                                                                return [WorkflowError errorWithCode:3 localizedDescription:@"No payform data detected."];
                                                                            }
                                                                            return nil;
                                                                       }];

    SBSDKUIWorkflow *workflow = [[SBSDKUIWorkflow alloc] initWithSteps:@[payform]
                                                                  name:@"Payform"
                                                     validationHandler:nil];
    
    return workflow;
}


+ (SBSDKUIWorkflow *)disabilityCertificate {

    NSArray *ratios = @[[[SBSDKPageAspectRatio alloc] initWithWidth:1.0 andHeight:1.414],
                        [[SBSDKPageAspectRatio alloc] initWithWidth:1.414 andHeight:1.0],
                        [[SBSDKPageAspectRatio alloc] initWithWidth:1.0 andHeight:1.5715]];
                        
    SBSDKUIWorkflowStep *certificate
    = [[SBSDKUIScanDisabilityCertificateWorkflowStep alloc] initWithTitle:@"Disability Certificate 1/1"
                                                                  message:@"Please scan your disability certificate."
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
    
    
    SBSDKUIWorkflow *workflow = [[SBSDKUIWorkflow alloc] initWithSteps:@[certificate]
                                                                  name:@"Disability Certificate"
                                                     validationHandler:nil];

    return workflow;
}

+ (SBSDKUIWorkflow *)blackWhiteDocument {
    
    NSArray *portrait = @[[[SBSDKPageAspectRatio alloc] initWithWidth:1.0 andHeight:1.414]];
    NSArray *landscape = @[[[SBSDKPageAspectRatio alloc] initWithWidth:1.414 andHeight:1.0]];

    SBSDKUIWorkflowStep *portraitStep
    = [[SBSDKUIScanDocumentPageWorkflowStep alloc] initWithTitle:@"Black & White Document 1/2"
                                                         message:@"Please scan a PORTRAIT A4 document."
                                            requiredAspectRatios:portrait
                                              pagePostProcessing:^(SBSDKUIPage *page) {
                                                  [page setFilter:SBSDKImageFilterTypeBlackAndWhite];
                                              }
                                                resultValidation:nil];
    
    SBSDKUIWorkflowStep *landscapeStep
    = [[SBSDKUIScanDocumentPageWorkflowStep alloc] initWithTitle:@"Black & White Document 2/2"
                                                         message:@"Please scan a LANDSCAPE A4 document."
                                            requiredAspectRatios:landscape
                                              pagePostProcessing:^(SBSDKUIPage *page) {
                                                  [page setFilter:SBSDKImageFilterTypeBlackAndWhite];
                                              }
                                                resultValidation:nil];

    SBSDKUIWorkflow *workflow = [[SBSDKUIWorkflow alloc] initWithSteps:@[portraitStep, landscapeStep]
                                                                  name:@"2-page, black and white document"
                                                     validationHandler:nil];
    
    return workflow;
}

+ (SBSDKUIWorkflow *)qrCodeAndDocument {
    
    SBSDKUIWorkflowStep *qrcodeStep
    = [[SBSDKUIScanBarCodeWorkflowStep alloc] initWithTitle:@"QR code and Document 1/2"
                                                        message:@"Please scan a QR code"
                                              acceptedCodeTypes:@[AVMetadataObjectTypeQRCode]
                                               resultValidation:nil];

    SBSDKUIWorkflowStep *documentStep
    = [[SBSDKUIScanDocumentPageWorkflowStep alloc] initWithTitle:@"QR code and Document 2/2"
                                                         message:@"Please scan a document."
                                            requiredAspectRatios:nil
                                              pagePostProcessing:nil
                                                resultValidation:nil];

    SBSDKUIWorkflow *workflow = [[SBSDKUIWorkflow alloc] initWithSteps:@[qrcodeStep, documentStep]
                                                                  name:@"QR code and document"
                                                     validationHandler:nil];
    
    return workflow;
}

+ (SBSDKUIWorkflowStep *)qrCodeStep {
    SBSDKUIWorkflowStep *qrcodeStep
    = [[SBSDKUIScanBarCodeWorkflowStep alloc] initWithTitle:@"Scan your QR code"
                                                        message:nil
                                              acceptedCodeTypes:@[AVMetadataObjectTypeQRCode]
                                               resultValidation:nil];
    return qrcodeStep;
}

+ (SBSDKUIWorkflowStep *)documentStep {
    SBSDKUIWorkflowStep *documentStep
    = [[SBSDKUIScanDocumentPageWorkflowStep alloc] initWithTitle:@"Scan your document"
                                                         message:nil
                                            requiredAspectRatios:nil
                                              pagePostProcessing:nil
                                                resultValidation:nil];
    return documentStep;
}

@end
