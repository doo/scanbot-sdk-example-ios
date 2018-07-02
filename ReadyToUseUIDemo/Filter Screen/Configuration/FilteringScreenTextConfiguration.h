//
//  FilteringScreenTextConfiguration.h
//  ScanbotSDKBeta
//
//  Created by Sebastian Husche on 19.06.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilteringScreenTextConfiguration : NSObject

/** String being displayed on the cancel button. */
@property (nullable, nonatomic, strong) NSString *cancelButtonTitle;

/** String being displayed on the done button. */
@property (nullable, nonatomic, strong) NSString *doneButtonTitle;

/** String being displayed on the filter button. */
@property (nullable, nonatomic, strong) NSString *filterButtonTitle;

/** String being displayed as the title
 on the top bar. */
@property (nullable, nonatomic, strong) NSString *topBarTitle;

@end
