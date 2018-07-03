//
//  PageReviewScreenUIConfiguration.h
//  ScanbotSDK
//
//  Created by Sebastian Husche on 30.04.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

/** Subconfiguration for user interface of the page preview screen. */
@interface PageReviewScreenUIConfiguration : NSObject

/** Foreground color of the top bars buttons. */
@property (nonnull, nonatomic, strong) UIColor *topBarButtonsColor;

/** Background color of the top bar. */
@property (nonnull, nonatomic, strong) UIColor *topBarBackgroundColor;

/** Foreground color of the rotate button. */
@property (nonnull, nonatomic, strong) UIColor *bottomBarButtonsColor;

/** Background color of the bottom bar. */
@property (nonnull, nonatomic, strong) UIColor *bottomBarBackgroundColor;

/** Text color of the title in the top bar. */
@property (nonnull, nonatomic, strong) UIColor *titleColor;

/** Size of a cell representing a page in the grid. */
@property (nonatomic, assign) CGSize cellSize;

/** Overlay color for a highlighted cell. */
@property (nonnull, nonatomic, strong) UIColor *cellHighlightColor;

@end
