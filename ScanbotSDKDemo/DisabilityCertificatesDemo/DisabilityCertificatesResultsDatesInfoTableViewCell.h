//
//  DisabilityCertificatesResultsDatesInfoTableViewCell.h
//  ScanbotSDKDemo
//
//  Created by Andrew Petrus on 15.02.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
@import ScanbotSDK;

@interface DisabilityCertificatesResultsDatesInfoTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *incapableSinceDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *incapableUntilDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *diagnosedOnDateLabel;

@property (nonatomic, weak) IBOutlet UILabel *incapableSinceRecognitionConfidenceValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *incapableSinceValidationConfidenceValueLabel;

@property (nonatomic, weak) IBOutlet UILabel *incapableUntilRecognitionConfidenceValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *incapableUntilValidationConfidenceValueLabel;

@property (nonatomic, weak) IBOutlet UILabel *diagnosedOnRecognitionConfidenceValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *diagnosedOnValidationConfidenceValueLabel;

- (void)updateCell:(SBSDKDisabilityCertificatesRecognizerResult *)recognitionResult;

@end
