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
        _topBarButtonsColor = [UIColor colorWithRed:0.968 green:0.807 blue:0.274 alpha:1.0];
        _topBarBackgroundColor = [UIColor blackColor];
        _titleColor = [UIColor whiteColor];
        _activityIndicatorColor = [UIColor blackColor];
        _backgroundColor = [UIColor colorWithRed:75.0/255.0 green:79.0/255.0 blue:82.0/255.0 alpha:1.0];
        
        _filterItemTextColor = [UIColor whiteColor];
        _filterItemAccessoryColor = [UIColor colorWithRed:0.968 green:0.807 blue:0.274 alpha:1.0];
        _filterItemBackgroundColor = [UIColor colorWithRed:28.0/255.0 green:28.0/255.0 blue:30.0/255.0 alpha:1.0];
        
        _filterItems = [FilterTableItem allItems];
    }
    return self;
}

@end
