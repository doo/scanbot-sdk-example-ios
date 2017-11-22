//
//  QRDescriptionViewController.h
//  SBSDK Internal Demo
//
//  Created by Yevgeniy Knizhnik on 10/11/17.
//  Copyright © 2017 doo GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QRDescriptionViewController;
@class SBSDKMachineReadableCode;

@protocol QRDescriptionViewControllerDelegate <NSObject>
@optional
- (void)qrDescriptionViewControllerWillDissmiss:(QRDescriptionViewController *)viewController;
@end

@interface QRDescriptionViewController : UIViewController
@property (nonatomic) CGFloat cornerRadius;
@property (strong, nonatomic) SBSDKMachineReadableCode *code;
@property (strong, nonatomic) UIColor *color;
@property (nonatomic, weak) id<QRDescriptionViewControllerDelegate> delegate;
@end
