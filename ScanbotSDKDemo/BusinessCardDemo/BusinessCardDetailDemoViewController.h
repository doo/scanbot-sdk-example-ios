//
//  BusinessCardDetailDemoViewController.h
//  SBSDK Internal Demo
//
//  Created by Yevgeniy Knizhnik on 9/26/18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BusinessCard: NSObject
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *recognizedText;

- (instancetype)initWith:(UIImage *)image recognizedText:(NSString *)text;

@end

@interface BusinessCardDetailDemoViewController: UIViewController
@property (nonatomic, strong) BusinessCard *businessCard;
@end

NS_ASSUME_NONNULL_END
