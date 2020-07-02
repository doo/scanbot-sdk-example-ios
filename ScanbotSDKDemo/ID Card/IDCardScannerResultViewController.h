//
//  IDCardScannerResultViewController.h
//  SBSDK Internal Demo
//
//  Created by Sebastian Husche on 22.05.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
@import ScanbotSDK;

NS_ASSUME_NONNULL_BEGIN

@interface IDCardScannerResultViewController : UIViewController

@property (nonatomic, readonly) SBSDKIDCardRecognizerResult* result;
@property (nonatomic, readonly) UIImage* sourceImage;

+ (instancetype)makeWithResult:(SBSDKIDCardRecognizerResult *)result sourceImage:(UIImage *)sourceImage;

@end

NS_ASSUME_NONNULL_END
