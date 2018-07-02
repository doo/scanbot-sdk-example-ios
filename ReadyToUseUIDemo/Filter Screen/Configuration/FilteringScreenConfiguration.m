//
//  FilteringScreenConfiguration.m
//  ScanbotSDKBeta
//
//  Created by Sebastian Husche on 19.06.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import "FilteringScreenConfiguration.h"

@implementation FilteringScreenConfiguration

- (nonnull instancetype)initWithUIConfiguration:(nonnull FilteringScreenUIConfiguration *)uiConfiguration
                              textConfiguration:(nonnull FilteringScreenTextConfiguration *)textConfiguration {
    self = [super init];
    if (self) {
        _uiConfiguration = uiConfiguration;
        _textConfiguration = textConfiguration;
    }
    return self;
}

+ (nonnull FilteringScreenConfiguration *)defaultConfiguration {
    FilteringScreenUIConfiguration* uiConf = [[FilteringScreenUIConfiguration alloc] init];
    FilteringScreenTextConfiguration* textConf = [[FilteringScreenTextConfiguration alloc] init];
    FilteringScreenConfiguration *conf
    = [[FilteringScreenConfiguration alloc] initWithUIConfiguration:uiConf textConfiguration:textConf];
    return conf;
}

@end
