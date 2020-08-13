//
//  PassportReaderResultTextTableViewCell.h
//  SBSDK Internal Demo
//
//  Created by Sebastian Husche on 13.05.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PassportReaderResultTextTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *keyLabel;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;

@end

NS_ASSUME_NONNULL_END
