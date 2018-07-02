//
//  PageReviewScreenConfiguration.h
//  ScanbotSDK
//
//  Created by Sebastian Husche on 27.04.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageReviewScreenUIConfiguration.h"
#import "PageReviewScreenTextConfiguration.h"

/**
 * This class describes the look and feel, as well as the textual contents of the page review screen.
 * Use the 'defaultConfiguration' class method to retrieve an instance and modify it.
 */
@interface PageReviewScreenConfiguration : NSObject

/** Not available. */
- (nonnull instancetype)init NS_UNAVAILABLE;

/** Not available. */
+ (nonnull instancetype)new NS_UNAVAILABLE;

/**
 * Designated initializer. Creates a new instance of 'PageReviewScreenConfiguration' and returns it.
 * @param uiConfiguration A subconfiguration for the user interface. Defines colors and sizes.
 * @param textConfiguration A subconfiguration for text being displayed in the page review screen.
 */
- (nonnull instancetype)initWithUIConfiguration:(nonnull PageReviewScreenUIConfiguration *)uiConfiguration
                              textConfiguration:(nonnull PageReviewScreenTextConfiguration *)textConfiguration
NS_DESIGNATED_INITIALIZER;

/**
 * The default configuration.
 * @return A mutable instance of 'PageReviewScreenConfiguration' with default values.
 */
+ (nonnull PageReviewScreenConfiguration *)defaultConfiguration;

/** The user interface subconfiguration. */
@property (nonnull, nonatomic, strong, readonly) PageReviewScreenUIConfiguration *uiConfiguration;

/** The subconfiguration for displayed texts. */
@property (nonnull, nonatomic, strong, readonly) PageReviewScreenTextConfiguration *textConfiguration;

@end
