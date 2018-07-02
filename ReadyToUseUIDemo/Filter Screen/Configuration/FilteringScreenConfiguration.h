//
//  FilteringScreenConfiguration.h
//  ScanbotSDKBeta
//
//  Created by Sebastian Husche on 19.06.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilteringScreenUIConfiguration.h"
#import "FilteringScreenTextConfiguration.h"

/**
 * This class describes the look and feel, as well as the textual contents of the page filtering screen.
 * Use the 'defaultConfiguration' class method to retrieve an instance and modify it.
 */
@interface FilteringScreenConfiguration : NSObject

/** Not available. */
- (nonnull instancetype)init NS_UNAVAILABLE;

/** Not available. */
+ (nonnull instancetype)new NS_UNAVAILABLE;

/**
 * Designated initializer. Creates a new instance of 'FilteringScreenConfiguration' and returns it.
 * @param uiConfiguration A subconfiguration for the user interface. Defines colors and sizes.
 * @param textConfiguration A subconfiguration for text being displayed in the page review screen.
 */
- (nonnull instancetype)initWithUIConfiguration:(nonnull FilteringScreenUIConfiguration *)uiConfiguration
                              textConfiguration:(nonnull FilteringScreenTextConfiguration *)textConfiguration
NS_DESIGNATED_INITIALIZER;

/**
 * The default configuration.
 * @return A mutable instance of 'FilteringScreenConfiguration' with default values.
 */
+ (nonnull FilteringScreenConfiguration *)defaultConfiguration;

/** The user interface subconfiguration. */
@property (nonnull, nonatomic, strong, readonly) FilteringScreenUIConfiguration *uiConfiguration;

/** The subconfiguration for displayed texts. */
@property (nonnull, nonatomic, strong, readonly) FilteringScreenTextConfiguration *textConfiguration;

@end
