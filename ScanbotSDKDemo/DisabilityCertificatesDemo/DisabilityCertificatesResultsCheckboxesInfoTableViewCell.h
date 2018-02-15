//
//  DisabilityCertificatesResultsCheckboxesInfoTableViewCell.h
//  ScanbotSDKDemo
//
//  Created by Andrew Petrus on 15.02.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
@import ScanbotSDK;

@interface DisabilityCertificatesResultsCheckboxesInfoTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *workAccidentStateLabel;
@property (nonatomic, weak) IBOutlet UILabel *assignedToInsuranceDoctorStateLabel;
@property (nonatomic, weak) IBOutlet UILabel *initialCertificateStateLabel;
@property (nonatomic, weak) IBOutlet UILabel *renewedCertificateStateLabel;

@property (nonatomic, weak) IBOutlet UILabel *workAccidentConfidenceValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *assignedToInsuranceDoctorConfidenceValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *initialCertificateConfidenceValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *renewedCertificateConfidenceValueLabel;

- (void)updateCell:(SBSDKDisabilityCertificatesRecognizerResult *)recognitionResult;

@end
