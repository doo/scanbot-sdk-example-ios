//
//  RecognizedQRCell.h
//  SBSDK Internal Demo
//
//  Created by Yevgeniy Knizhnik on 10/11/17.
//  Copyright © 2017 doo GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecognizedQRCell : UITableViewCell
@property (strong, nonatomic) NSString *infoText;
@property (nonatomic, readonly) CGRect bubbleRect;
@property (strong, nonatomic) UIColor *bubbleColor;
@property (nonatomic, readonly) CGFloat bubbleCornerRadius;
@end
