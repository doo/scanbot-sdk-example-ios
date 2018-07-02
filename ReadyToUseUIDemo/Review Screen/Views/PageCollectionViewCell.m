//
//  SBSDKUIPageCollectionViewCell.m
//  ScanbotSDK
//
//  Created by Sebastian Husche on 30.04.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import "PageCollectionViewCell.h"
@import ScanbotSDK;

@implementation PageCollectionViewCell

- (void)setHighlighted:(BOOL)highlighted {
    [self layoutHighlightView];
    [super setHighlighted:highlighted];
    UIViewAnimationOptions options = (UIViewAnimationOptionAllowUserInteraction
                                      | UIViewAnimationOptionBeginFromCurrentState
                                      | UIViewAnimationOptionCurveEaseInOut);
    [UIView animateWithDuration:0.01 delay:0.0 options:options animations:^{
        self.highlightView.alpha = highlighted ? 1.0 : 0.0;
    } completion:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutHighlightView];
}

- (void)layoutHighlightView {
    self.highlightView.frame = [self highlightFrame];
}

- (CGRect)highlightFrame {
    if (self.imageView.image == nil) {
        return self.imageView.frame;
    }
    CGSize imageSize = self.imageView.image.size;
    CGRect imageRect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    switch (self.imageView.contentMode) {
        case UIViewContentModeScaleAspectFit:
            return RectFitInRect(imageRect, self.imageView.frame);
        case UIViewContentModeCenter: {
            CGRect centerRect = imageRect;
            centerRect.size.width = MIN(centerRect.size.width, self.imageView.frame.size.width);
            centerRect.size.height = MIN(centerRect.size.height, self.imageView.frame.size.height);
            return RectCenterInRect(centerRect, self.imageView.frame);
        }
        default:
            return self.imageView.frame;
    }
}

@end
