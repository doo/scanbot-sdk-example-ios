//
//  PageReviewScreenTextConfiguration.h
//  ScanbotSDK
//
//  Created by Sebastian Husche on 30.04.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

/** Subconfiguration for the textual content of the page preview screen. */
@interface PageReviewScreenTextConfiguration : NSObject

/** String being displayed on the top right button. Defaults to "Close". */
@property (nullable, nonatomic, strong) NSString *topRightButtonTitle;

/** String being displayed on the top left button. Defaults to nil. */
@property (nullable, nonatomic, strong) NSString *topLeftButtonTitle;

/** String being displayed on the bottom button. Defaults to "Delete All Scans". */
@property (nullable, nonatomic, strong) NSString *bottomButtonTitle;

/** String being displayed as the title on the top bar. */
@property (nullable, nonatomic, strong) NSString *topBarTitle;

@end
