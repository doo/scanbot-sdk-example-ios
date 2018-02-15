//
//  DisabilityCertificatesRecognizerResultViewController.h
//  ScanbotSDKDemo
//
//  Created by Andrew Petrus on 15.02.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@import ScanbotSDK;

@interface DisabilityCertificatesRecognizerResultViewController : UITableViewController

@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) SBSDKDisabilityCertificatesRecognizerResult *initialResult;

@end
