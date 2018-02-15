//
//  DisabilityCertificatesResultsCheckboxesInfoTableViewCell.m
//  ScanbotSDKDemo
//
//  Created by Andrew Petrus on 15.02.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import "DisabilityCertificatesResultsCheckboxesInfoTableViewCell.h"

@implementation DisabilityCertificatesResultsCheckboxesInfoTableViewCell

- (void)updateCell:(SBSDKDisabilityCertificatesRecognizerResult *)recognitionResult {
    self.workAccidentStateLabel.text = @"Unchecked";
    self.assignedToInsuranceDoctorStateLabel.text = @"Unchecked";
    self.initialCertificateStateLabel.text = @"Unchecked";
    self.renewedCertificateStateLabel.text = @"Unchecked";
    
    self.workAccidentConfidenceValueLabel.text = @"0";
    self.assignedToInsuranceDoctorConfidenceValueLabel.text = @"0";
    self.initialCertificateConfidenceValueLabel.text = @"0";
    self.renewedCertificateConfidenceValueLabel.text = @"0";
    
    if (recognitionResult.checkboxes && recognitionResult.checkboxes.count > 0) {
        for (SBSDKDisabilityCertificatesRecognizerCheckboxResult *checkbox in recognitionResult.checkboxes) {
            if (checkbox.type == SBSDKDisabilityCertificateRecognizerCheckboxTypeWorkAccident) {
                self.workAccidentStateLabel.text = checkbox.isChecked ? @"Checked" : @"Unchecked";
                self.workAccidentConfidenceValueLabel.text = [NSString stringWithFormat:@"%f", checkbox.confidenceValue];
            } else if (checkbox.type == SBSDKDisabilityCertificateRecognizerCheckboxTypeAssignedToAccidentInsuranceDoctor) {
                self.assignedToInsuranceDoctorStateLabel.text = checkbox.isChecked ? @"Checked" : @"Unchecked";
                self.assignedToInsuranceDoctorConfidenceValueLabel.text = [NSString stringWithFormat:@"%f", checkbox.confidenceValue];
            } else if (checkbox.type == SBSDKDisabilityCertificateRecognizerCheckboxTypeInitialCertificate) {
                self.initialCertificateStateLabel.text = checkbox.isChecked ? @"Checked" : @"Unchecked";
                self.initialCertificateConfidenceValueLabel.text = [NSString stringWithFormat:@"%f", checkbox.confidenceValue];
            } else if (checkbox.type == SBSDKDisabilityCertificateRecognizerCheckboxTypeRenewedCertificate) {
                self.renewedCertificateStateLabel.text = checkbox.isChecked ? @"Checked" : @"Unchecked";
                self.renewedCertificateConfidenceValueLabel.text = [NSString stringWithFormat:@"%f", checkbox.confidenceValue];
            }
        }
    }
}

@end
