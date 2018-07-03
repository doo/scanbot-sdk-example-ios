//
//  PageReviewScreenTextConfiguration.m
//  ScanbotSDK
//
//  Created by Sebastian Husche on 30.04.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import "PageReviewScreenTextConfiguration.h"

@implementation PageReviewScreenTextConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        _bottomButtonTitle = @"Delete All Scans";
        _topRightButtonTitle = @"Close";
        _topLeftButtonTitle = @"Back";
        _topBarTitle = @"Scan Results";
    }
    return self;
}

@end
