//
//  RecognizedQRCell.m
//  SBSDK Internal Demo
//
//  Created by Yevgeniy Knizhnik on 10/11/17.
//  Copyright © 2017 doo GmbH. All rights reserved.
//

#import "RecognizedQRCell.h"

@interface RecognizedQRCell ()
@property (strong, nonatomic) IBOutlet UIView *bubble;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bubbleLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bubbleTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bubbleBottomConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bublbeTrailingConstraint;

@end

static CGFloat const kVerticalMargin = 8;
static CGFloat const kHorizontalMargin = 0;
static CGFloat const kSelectedHorizontalMargin = -8;
static CGFloat const kSelectedVerticalMargin = 0;

@implementation RecognizedQRCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self updateInfoText];
    [self updateColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    self.bubbleLeadingConstraint.constant = selected ? kSelectedHorizontalMargin : kHorizontalMargin;
    self.bublbeTrailingConstraint.constant = selected ? kSelectedHorizontalMargin : kHorizontalMargin;
    self.bubbleTopConstraint.constant = selected ? kSelectedVerticalMargin : kVerticalMargin;
    self.bubbleBottomConstraint.constant = selected ? kSelectedVerticalMargin : kVerticalMargin;
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self layoutIfNeeded];
        self.infoLabel.alpha = selected ? 0 : 1;
    } completion:nil];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.bubbleLeadingConstraint.constant = highlighted ? kSelectedHorizontalMargin : kHorizontalMargin;
    self.bublbeTrailingConstraint.constant = highlighted ? kSelectedHorizontalMargin : kHorizontalMargin;
    self.bubbleTopConstraint.constant = highlighted ? kSelectedVerticalMargin : kVerticalMargin;
    self.bubbleBottomConstraint.constant = highlighted ? kSelectedVerticalMargin : kVerticalMargin;
    [UIView animateWithDuration:0.4
                          delay:highlighted ? 0.0 : 0.1
         usingSpringWithDamping:0.5
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{ [self layoutIfNeeded]; }
                     completion:nil];
}

- (void)setInfoText:(NSString *)infoText {
    _infoText = infoText;
    [self updateInfoText];
}

- (void)setBubbleColor:(UIColor *)bubbleColor {
    _bubbleColor = bubbleColor;
    [self updateColor];
}

- (void)updateInfoText {
    self.infoLabel.text = self.infoText;
}

- (void)updateColor {
    self.bubble.backgroundColor = self.bubbleColor;
}

- (CGRect)bubbleRect {
    return self.bubble.frame;
}

- (CGFloat)bubbleCornerRadius {
    return self.bubble.layer.cornerRadius;
}

@end
