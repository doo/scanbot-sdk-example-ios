//
//  FilterModel.m
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 30.01.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

#import "FilterModel.h"

@implementation FilterModel

- (instancetype)initWithName:(NSString *)name changeHandler:(ChangeHandler)changeHandler
                    minValue:(CGFloat)minValue
                    maxValue:(CGFloat)maxValue {
    if ([super init]) {
        _name = name;
        _maxValue = maxValue;
        _minValue = minValue;
        _value = 0.0f;
        _changeHandler = [changeHandler copy];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name changeHandler:(ChangeHandler)changeHandler {
    if ([super init]) {
        _name = name;
        _maxValue = 0.66;
        _minValue = -0.66;
        _value = 0.0f;
        _changeHandler = [changeHandler copy];
    }
    return self;
}

- (void)setValue:(CGFloat)value {
    _value = MAX(MIN(value, self.maxValue), self.minValue);
    self.changeHandler(_value);
}

@end
