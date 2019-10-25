//
//  BarCodeScannerResultsTableViewCell.h
//  ScanbotSDK Demo
//
//  Created by Andrew Petrus on 29.01.19.
//  Copyright © 2019 doo GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BarCodeScannerResultsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *barcodeText;
@property (weak, nonatomic) IBOutlet UILabel *barCodeType;
@property (weak, nonatomic) IBOutlet UIImageView *barcodeImage;

@end

NS_ASSUME_NONNULL_END
