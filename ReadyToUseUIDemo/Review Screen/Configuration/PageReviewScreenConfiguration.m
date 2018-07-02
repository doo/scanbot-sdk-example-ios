//
//  PageReviewScreenConfiguration.m
//  ScanbotSDK
//
//  Created by Sebastian Husche on 27.04.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import "PageReviewScreenConfiguration.h"

@implementation PageReviewScreenConfiguration

- (nonnull instancetype)initWithUIConfiguration:(nonnull PageReviewScreenUIConfiguration *)uiConfiguration
                              textConfiguration:(nonnull PageReviewScreenTextConfiguration *)textConfiguration {
    self = [super init];
    if (self) {
        _uiConfiguration = uiConfiguration;
        _textConfiguration = textConfiguration;
    }
    return self;
}

+ (nonnull PageReviewScreenConfiguration *)defaultConfiguration {
    PageReviewScreenUIConfiguration* uiConf = [[PageReviewScreenUIConfiguration alloc] init];
    PageReviewScreenTextConfiguration* textConf = [[PageReviewScreenTextConfiguration alloc] init];
    PageReviewScreenConfiguration *conf
    = [[PageReviewScreenConfiguration alloc] initWithUIConfiguration:uiConf textConfiguration:textConf];
    return conf;
}

@end
