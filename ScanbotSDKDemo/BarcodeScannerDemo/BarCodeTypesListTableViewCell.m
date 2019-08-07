//
//  BarCodeTypesListTableViewCell.m
//  SBSDK Internal Demo
//
//  Created by Andrew Petrus on 13.05.19.
//  Copyright © 2019 doo GmbH. All rights reserved.
//

#import "BarCodeTypesListTableViewCell.h"

@implementation BarCodeTypesListTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.stateCheckedImageView.hidden = !selected;
}

@end
