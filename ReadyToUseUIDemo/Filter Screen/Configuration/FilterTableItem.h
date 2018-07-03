//
//  FilterTableItem.h
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 03.07.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
@import ScanbotSDK;

@interface FilterTableItem : NSObject

@property(nonnull, nonatomic, readonly) NSString *title;
@property(nonatomic, readonly) SBSDKImageFilterType filterType;

- (instancetype _Nonnull )initWithTitle:(nonnull NSString *)title filterType:(SBSDKImageFilterType)filter;

+ (nonnull NSArray<FilterTableItem*>*)allItems;

@end
