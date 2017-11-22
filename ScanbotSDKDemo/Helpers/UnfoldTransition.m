//
//  UnfoldTransition.m
//  SBSDK Internal Demo
//
//  Created by Yevgeniy Knizhnik on 10/11/17.
//  Copyright © 2017 doo GmbH. All rights reserved.
//

#import "UnfoldTransition.h"

@interface UnfoldTransition ()
@property (nonatomic) CGRect initialFrame;
@property (nonatomic) CGFloat initialRadius;
@property (nonatomic, strong) UIColor *initialColor;
@end

@implementation UnfoldTransition

- (instancetype)init {
    self = [super init];
    if (self) {
        _initialFrame = CGRectZero;
        _initialRadius = 0.0;
        _initialColor = [UIColor grayColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame cornerRadius:(CGFloat)radius color:(UIColor *)color {
    self = [super init];
    if (self) {
        _initialFrame = frame;
        _initialRadius = radius;
        _initialColor = color;
    }
    return self;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *destinationVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [destinationVC.view setHidden:YES];
    CGRect finalFrame = [transitionContext finalFrameForViewController:destinationVC];

    UIView *mockBackgroundView = [[UIView alloc] initWithFrame:finalFrame];
    mockBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    mockBackgroundView.alpha = 0.0;
    [transitionContext.containerView addSubview:mockBackgroundView];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *mockBubbleView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    mockBubbleView.clipsToBounds = YES;
    mockBubbleView.layer.cornerRadius = self.initialRadius;
    mockBubbleView.backgroundColor = self.initialColor;
    [transitionContext.containerView addSubview:mockBubbleView];
    mockBubbleView.translatesAutoresizingMaskIntoConstraints = NO;
    mockBubbleView.alpha = 0.0;
    NSLayoutConstraint *centerXConstraint = [mockBubbleView.centerXAnchor
                                             constraintEqualToAnchor:transitionContext.containerView.centerXAnchor
                                             constant:CGRectGetMidX(self.initialFrame)
                                                 - (transitionContext.containerView.frame.size.width/2)];
    NSLayoutConstraint *centerYConstraint = [mockBubbleView.centerYAnchor
                                             constraintEqualToAnchor:transitionContext.containerView.centerYAnchor
                                             constant:CGRectGetMidY(self.initialFrame)
                                             - (transitionContext.containerView.frame.size.height/2)];
    NSLayoutConstraint *widthConstraint = [mockBubbleView.widthAnchor
                                           constraintEqualToConstant:self.initialFrame.size.width];
    NSLayoutConstraint *heightConstraint = [mockBubbleView.heightAnchor
                                            constraintLessThanOrEqualToConstant:self.initialFrame.size.height];
    NSLayoutConstraint *topConstraint = [mockBubbleView.topAnchor
                                         constraintEqualToAnchor:transitionContext.containerView.topAnchor
                                         constant:0];
    topConstraint.priority = UILayoutPriorityDefaultHigh;
    NSLayoutConstraint *bottomConstraint = [mockBubbleView.bottomAnchor
                                            constraintEqualToAnchor:transitionContext.containerView.bottomAnchor
                                            constant:0];
    bottomConstraint.priority = UILayoutPriorityDefaultHigh;
    [NSLayoutConstraint activateConstraints:@[centerXConstraint, centerYConstraint, topConstraint, bottomConstraint,
                                              widthConstraint, heightConstraint]];
    [transitionContext.containerView layoutIfNeeded];

    centerXConstraint.constant = 0;
    centerYConstraint.constant = 0;
    widthConstraint.constant = 288;
    heightConstraint.constant = 400;    
    
    UIView *destinationView = [transitionContext viewForKey:UITransitionContextToViewKey];
    destinationView.frame = finalFrame;
    [transitionContext.containerView addSubview:destinationView];
    
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.6
                                                                                  curve:UIViewAnimationCurveEaseOut
                                                                             animations:^{
          [UIView animateKeyframesWithDuration:0 delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState
                                    animations:^{
                                        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.3 animations:^{
                                            mockBubbleView.alpha = 1.0;
                                        }];
                                        [UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:0.7 animations:^{
                                            [transitionContext.containerView layoutIfNeeded];
                                            mockBackgroundView.alpha = 1.0;
                                        }];
                                    } completion:nil];
    }];
    [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
        [destinationVC.view setHidden:NO];
        [mockBubbleView removeFromSuperview];
        [mockBackgroundView removeFromSuperview];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    [animator startAnimation];
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}

@end
