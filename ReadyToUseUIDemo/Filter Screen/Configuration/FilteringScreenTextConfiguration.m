//
//  FilteringScreenTextConfiguration.m
//  ScanbotSDKBeta
//
//  Created by Sebastian Husche on 19.06.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import "FilteringScreenTextConfiguration.h"

@implementation FilteringScreenTextConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        _cancelButtonTitle = @"Cancel";
        _doneButtonTitle = @"Done";
        _topBarTitle = @"Filter";
        _filterButtonTitle = @"Choose Filter";
    }
    return self;
}

@end
