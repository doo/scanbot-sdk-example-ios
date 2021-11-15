//
//  FilterModel.h
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 30.01.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

@import UIKit;

typedef void (^ChangeHandler)(CGFloat);

NS_ASSUME_NONNULL_BEGIN

@interface FilterModel : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, assign) CGFloat minValue;
@property(nonatomic, assign) CGFloat maxValue;
@property(nonatomic, assign) CGFloat value;
@property(nonatomic, copy) ChangeHandler changeHandler;

- (instancetype)initWithName:(NSString *)name changeHandler:(ChangeHandler)changeHandler
                    minValue:(CGFloat)minValue
                    maxValue:(CGFloat)maxValue;


- (instancetype)initWithName:(NSString *)name changeHandler:(ChangeHandler)changeHandler;

@end

NS_ASSUME_NONNULL_END
