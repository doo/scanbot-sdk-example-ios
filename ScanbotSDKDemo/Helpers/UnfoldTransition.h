//
//  UnfoldTransition.h
//  SBSDK Internal Demo
//
//  Created by Yevgeniy Knizhnik on 10/11/17.
//  Copyright © 2017 doo GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnfoldTransition : NSObject<UIViewControllerAnimatedTransitioning>
- (instancetype)initWithFrame:(CGRect)frame cornerRadius:(CGFloat)radius color:(UIColor *)color;
@end
