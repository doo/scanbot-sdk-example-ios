//
//  FilterTableViewCell.m
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 03.07.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import "FilterTableViewCell.h"

@implementation FilterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundView = [[UIView alloc] init];
    self.selectedBackgroundView = [[UIView alloc] init];
}

@end
