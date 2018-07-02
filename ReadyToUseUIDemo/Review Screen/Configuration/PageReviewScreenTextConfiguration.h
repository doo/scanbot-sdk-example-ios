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

/** String being displayed on the close button. */
@property (nullable, nonatomic, strong) NSString *closeButtonTitle;

/** String being displayed as the title on the top bar. */
@property (nullable, nonatomic, strong) NSString *topBarTitle;

@end
