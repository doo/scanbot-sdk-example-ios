//
//  FilterTableViewCell.h
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 30.01.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

@import UIKit;
#import "FilterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FilterTableViewCell : UITableViewCell

@property (nonatomic, strong) FilterModel* filterModel;

@end

NS_ASSUME_NONNULL_END
