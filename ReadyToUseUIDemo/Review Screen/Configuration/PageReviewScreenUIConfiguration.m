//
//  PageReviewScreenUIConfiguration.m
//  ScanbotSDK
//
//  Created by Sebastian Husche on 30.04.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import "PageReviewScreenUIConfiguration.h"

@implementation PageReviewScreenUIConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        _topBarButtonsColor = [UIColor colorWithRed:0.968 green:0.807 blue:0.274 alpha:1.0];
        _topBarBackgroundColor = [UIColor blackColor];
        
        _bottomBarButtonsColor = [UIColor colorWithRed:0.968 green:0.807 blue:0.274 alpha:1.0];
        _bottomBarBackgroundColor = [UIColor blackColor];
        
        _titleColor = [UIColor whiteColor];
        
        _cellSize = CGSizeMake(144, 200);
        _cellHighlightColor = [[UIColor blackColor] colorWithAlphaComponent:0.66];
    }
    return self;
}

@end
