//
//  PageReviewViewController.h
//  ScanbotSDK
//
//  Created by Sebastian Husche on 27.04.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

@import ScanbotSDK;
#import <UIKit/UIKit.h>
#import "PageReviewScreenConfiguration.h"

@class PageReviewViewController;

/** Delegate protocol for 'PageReviewViewController'. */
@protocol PageReviewViewControllerDelegate <SBSDKUIViewControllerDelegate>

/**
 * Informs the delegate that the user selected a 'SBSDKUIPage'.
 * @param viewController The 'PageReviewViewController' in which the user selected a page.
 * @param page The 'SBSDKUIPage' instance the user selected.
 */
- (void)pageReviewViewController:(nonnull PageReviewViewController *)viewController
                       didSelect:(nonnull SBSDKUIPage *)page;

@optional
/**
 * Optional: informs the delegate that the 'PageReviewViewController' has been dismissed.
 * @param viewController The 'PageReviewViewController' that did dismiss.
 */
- (void)pageReviewViewControllerDidCancel:(nonnull PageReviewViewController *)viewController;

@end

/**
 * A view controller displaying a scrollable grid of captured pages ('SBSDKUIPage').
 * The user browse all pages and tap on any page to display an editor or viewer for it.
 */
@interface PageReviewViewController : SBSDKUIViewController

/**
 * Creates a new instance of 'PageReviewViewController' and presents it modally.
 * @param presenter The view controller the new instance should be presented on.
 * @param document The document whose pages should be displayed.
 * @param configuration The configuration to define look and feel of the new page review view controller.
 * @param delegate The delegate of the new page review view controller.
 * @return A new instance of 'PageReviewViewController'.
 */
+ (nonnull instancetype)presentOn:(nonnull UIViewController *)presenter
                     withDocument:(nonnull SBSDKUIDocument *)document
                withConfiguration:(nonnull PageReviewScreenConfiguration *)configuration
                      andDelegate:(nullable id<PageReviewViewControllerDelegate>)delegate;

/**
 * Creates a new instance of 'PageReviewViewController'.
 * @param document The document whose pages should be displayed.
 * @param configuration The configuration to define look and feel of the new page review view controller.
 * @param delegate The delegate of the new page review view controller.
 * @return A new instance of 'PageReviewViewController' which can be presented in any way.
 */
+ (nonnull instancetype)createNewWithDocument:(nonnull SBSDKUIDocument *)document
                            withConfiguration:(nonnull PageReviewScreenConfiguration *)configuration
                                  andDelegate:(nullable id<PageReviewViewControllerDelegate>)delegate;

/** The receivers delegate. */
@property (nullable, nonatomic, weak) id <PageReviewViewControllerDelegate> delegate;

- (void)reloadData;

@end
