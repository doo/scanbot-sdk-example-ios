//
//  BarCodeScannerResultsTableViewController.h
//  SBSDK Internal Demo
//
//  Created by Andrew Petrus on 24.01.19.
//  Copyright © 2019 doo GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
@import ScanbotSDK;

NS_ASSUME_NONNULL_BEGIN

@interface BarCodeScannerResultsTableViewController : UITableViewController

@property (nonatomic, strong) NSArray<SBSDKBarcodeScannerResult *> *results;

@end

NS_ASSUME_NONNULL_END
