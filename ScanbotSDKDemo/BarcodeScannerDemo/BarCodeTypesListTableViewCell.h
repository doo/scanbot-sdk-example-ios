//
//  BarCodeTypesListTableViewCell.h
//  SBSDK Internal Demo
//
//  Created by Andrew Petrus on 13.05.19.
//  Copyright © 2019 doo GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BarCodeTypesListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *barCodeTypaNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stateCheckedImageView;

@end

NS_ASSUME_NONNULL_END
