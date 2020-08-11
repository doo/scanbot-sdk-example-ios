//
//  BarCodesResultDetailsViewController.h
//  ScanbotSDK Demo
//
//  Created by Andrew Petrus on 13.05.19.
//  Copyright © 2019 doo GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
@import ScanbotSDK;

NS_ASSUME_NONNULL_BEGIN

@interface BarCodesResultDetailsViewController : UITableViewController

@property (nonatomic, strong) SBSDKBarCodeScannerDocumentFormat *barcodeFormat;
@property (nonatomic, strong) UIImage *barCodeImage;
@property (nonatomic, strong) NSString *barCodeText;
@property (nonatomic, strong) NSData *barCodeRawBytes;

@end

NS_ASSUME_NONNULL_END
