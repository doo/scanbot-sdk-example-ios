//
//  FilterTableItem.m
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 03.07.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import "FilterTableItem.h"

@interface FilterTableItem()
@property(nonnull, nonatomic, copy, readwrite) NSString *title;
@property(nonatomic, assign, readwrite) SBSDKImageFilterType filterType;
@end

@implementation FilterTableItem

- (instancetype)initWithTitle:(nonnull NSString *)title filterType:(SBSDKImageFilterType)filter {
    self = [super init];
    if (self) {
        _title = [title copy];
        _filterType = filter;
    }
    return self;
}

+ (NSArray<FilterTableItem*>*)allItems {
    return @[
             [[FilterTableItem alloc] initWithTitle:@"None" filterType:SBSDKImageFilterTypeNone],
             [[FilterTableItem alloc] initWithTitle:@"Color" filterType:SBSDKImageFilterTypeColor],
             [[FilterTableItem alloc] initWithTitle:@"Gray" filterType:SBSDKImageFilterTypeGray],
             [[FilterTableItem alloc] initWithTitle:@"Binarized" filterType:SBSDKImageFilterTypeBinarized],
             [[FilterTableItem alloc] initWithTitle:@"ColorDocument" filterType:SBSDKImageFilterTypeColorDocument],
             [[FilterTableItem alloc] initWithTitle:@"PureBinarized" filterType:SBSDKImageFilterTypePureBinarized],
             [[FilterTableItem alloc] initWithTitle:@"BackgroundClean" filterType:SBSDKImageFilterTypeBackgroundClean],
             [[FilterTableItem alloc] initWithTitle:@"BlackAndWhite" filterType:SBSDKImageFilterTypeBlackAndWhite],
             [[FilterTableItem alloc] initWithTitle:@"OtsuBinarization" filterType:SBSDKImageFilterTypeOtsuBinarization],
             [[FilterTableItem alloc] initWithTitle:@"DeepBinarization" filterType:SBSDKImageFilterTypeDeepBinarization],
             [[FilterTableItem alloc] initWithTitle:@"EdgeHighlight" filterType:SBSDKImageFilterTypeEdgeHighlight],
             [[FilterTableItem alloc] initWithTitle:@"LowLightBinarization" filterType:SBSDKImageFilterTypeLowLightBinarization],
      ];
}

@end
