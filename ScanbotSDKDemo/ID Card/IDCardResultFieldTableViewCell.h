//
//  IDCardResultFieldTableViewCell.h
//  SBSDK Internal Demo
//
//  Created by Sebastian Husche on 22.05.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IDCardResultFieldTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *fieldTypeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *fieldImageView;
@property (strong, nonatomic) IBOutlet UILabel *recognizedTextInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *recognizedTextLabel;
@end

NS_ASSUME_NONNULL_END
