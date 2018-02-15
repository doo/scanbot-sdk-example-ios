//
//  DisabilityCertificatesResultsDatesInfoTableViewCell.m
//  ScanbotSDKDemo
//
//  Created by Andrew Petrus on 15.02.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import "DisabilityCertificatesResultsDatesInfoTableViewCell.h"

@implementation DisabilityCertificatesResultsDatesInfoTableViewCell

- (void)updateCell:(SBSDKDisabilityCertificatesRecognizerResult *)recognitionResult {
    self.incapableSinceDateLabel.text = @"-";
    self.incapableUntilDateLabel.text = @"-";
    self.diagnosedOnDateLabel.text = @"-";
    
    self.incapableSinceRecognitionConfidenceValueLabel.text = @"0";
    self.incapableSinceValidationConfidenceValueLabel.text = @"0";
    
    self.incapableUntilRecognitionConfidenceValueLabel.text = @"0";
    self.incapableUntilValidationConfidenceValueLabel.text = @"0";
    
    self.diagnosedOnRecognitionConfidenceValueLabel.text = @"0";
    self.diagnosedOnValidationConfidenceValueLabel.text = @"0";
    
    if (recognitionResult.dates && recognitionResult.dates.count > 0) {
        for (SBSDKDisabilityCertificatesRecognizerDateResult *date in recognitionResult.dates) {
            if (date.dateRecordType == SBSDKDisabilityCertificateRecognizerDateResultTypeIncapableOfWorkSince) {
                self.incapableSinceDateLabel.text = date.dateString;
                self.incapableSinceRecognitionConfidenceValueLabel.text = [NSString stringWithFormat:@"%f", date.recognitionConfidence];
                self.incapableSinceValidationConfidenceValueLabel.text = [NSString stringWithFormat:@"%f", date.validationConfidence];
            } else if (date.dateRecordType == SBSDKDisabilityCertificateRecognizerDateResultTypeIncapableOfWorkUntil) {
                self.incapableUntilDateLabel.text = date.dateString;
                self.incapableUntilRecognitionConfidenceValueLabel.text = [NSString stringWithFormat:@"%f", date.recognitionConfidence];
                self.incapableUntilValidationConfidenceValueLabel.text = [NSString stringWithFormat:@"%f", date.validationConfidence];
            } else if (date.dateRecordType == SBSDKDisabilityCertificateRecognizerDateResultTypeDiagnosedOn) {
                self.diagnosedOnDateLabel.text = date.dateString;
                self.diagnosedOnRecognitionConfidenceValueLabel.text = [NSString stringWithFormat:@"%f", date.recognitionConfidence];
                self.diagnosedOnValidationConfidenceValueLabel.text = [NSString stringWithFormat:@"%f", date.validationConfidence];
            }
        }
    }
}

@end
