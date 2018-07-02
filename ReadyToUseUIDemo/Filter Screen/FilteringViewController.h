//
//  FilteringViewController.h
//  ScanbotSDKBeta
//
//  Created by Sebastian Husche on 19.06.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

@import ScanbotSDK;
#import <UIKit/UIKit.h>
#import "FilteringScreenConfiguration.h"

@class FilteringViewController;

/** Delegate protocol for 'SBSDKUICroppingViewController'. */
@protocol FilteringViewControllerDelegate <SBSDKUIViewControllerDelegate>

/**
 * Informs the delegate that the filter of the edited page was changed
 * and the filtering view controller did dismiss.
 * @param viewController The editing filter view controller that initiated the change and that did dismiss.
 * @param changedPage The page that was changed.
 */
- (void)filteringViewController:(nonnull FilteringViewController *)viewController
                      didFinish:(nonnull SBSDKUIPage *)changedPage;

@optional
/**
 * Optional: Informs the delegate that the 'FilteringViewController' has been cancelled and dismissed.
 * @param viewController The 'FilteringViewController' that did dismiss.
 */
- (void)filteringViewControllerDidCancel:(nonnull FilteringViewController *)viewController;

@end


@interface FilteringViewController : SBSDKUIViewController

/**
 * Creates a new instance of 'FilteringViewController' and presents it modally.
 * @param presenter The view controller the new instance should be presented on.
 * @param page The page to be filtered.
 * @param configuration The configuration to define look and feel of the new page filtering view controller.
 * @param delegate The delegate of the new page filtering view controller.
 * @return A new instance of 'SBSDKUICroppingViewController'.
 */
+ (nonnull instancetype)presentOn:(nonnull UIViewController *)presenter
                         withPage:(nonnull SBSDKUIPage *)page
                withConfiguration:(nonnull FilteringScreenConfiguration *)configuration
                      andDelegate:(nullable id<FilteringViewControllerDelegate>)delegate;

/**
 * Creates a new instance of 'FilteringViewController'.
 * @param page The page to be filtered.
 * @param configuration The configuration to define look and feel of the new page filtering view controller.
 * @param delegate The delegate of the new page filtering view controller.
 * @return A new instance of 'FilteringViewController'.
 */
+ (nonnull instancetype)createNewWithPage:(nonnull SBSDKUIPage *)page
                        withConfiguration:(nonnull FilteringScreenConfiguration *)configuration
                              andDelegate:(nullable id<FilteringViewControllerDelegate>)delegate;

/** The receivers delegate. */
@property (nullable, nonatomic, weak) id <FilteringViewControllerDelegate> delegate;

@end
