//
//  FilteringScreenUIConfiguration.h
//  ScanbotSDKBeta
//
//  Created by Sebastian Husche on 19.06.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilteringScreenUIConfiguration : NSObject

/** Foreground color of the top bar buttons (Done, Cancel). */
@property (nonnull, nonatomic, strong) UIColor *topBarButtonsColor;

/** Background color of the top bar. */
@property (nonnull, nonatomic, strong) UIColor *topBarBackgroundColor;

/** Text color of the title in the top bar. */
@property (nonnull, nonatomic, strong) UIColor *titleColor;

/** Foreground color of the rotate button. */
@property (nonnull, nonatomic, strong) UIColor *bottomBarButtonsColor;

/** Background color of the bottom bar. */
@property (nonnull, nonatomic, strong) UIColor *bottomBarBackgroundColor;

/** Background color of the view. Same as `viewController.view.backgroundColor`.*/
@property (nonnull, nonatomic, strong) UIColor *backgroundColor;

/** Foreground color of the loading indicator. */
@property (nonnull, nonatomic, strong) UIColor *activityIndicatorColor;


@end
