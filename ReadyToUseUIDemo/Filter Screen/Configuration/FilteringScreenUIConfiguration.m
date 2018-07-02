//
//  FilteringScreenUIConfiguration.m
//  ScanbotSDKBeta
//
//  Created by Sebastian Husche on 19.06.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import "FilteringScreenUIConfiguration.h"

@implementation FilteringScreenUIConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        _bottomBarButtonsColor = [UIColor colorWithRed:0.968 green:0.807 blue:0.274 alpha:1.0];
        _bottomBarBackgroundColor = [UIColor blackColor];
        
        _topBarButtonsColor = [UIColor colorWithRed:0.968 green:0.807 blue:0.274 alpha:1.0];
        
        _topBarBackgroundColor = [UIColor blackColor];
        _titleColor = [UIColor whiteColor];
        
        _activityIndicatorColor = [UIColor blackColor];
        
        _backgroundColor = [UIColor colorWithRed:0.901 green:0.901 blue:0.901 alpha:1.0];
    }
    return self;
}

@end
