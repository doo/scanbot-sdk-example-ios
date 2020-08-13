//
//  PassportReaderResultsViewController.h
//  SBSDK Internal Demo
//
//  Created by Sebastian Husche on 11.05.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SBSDKNFCDatagroup;

NS_ASSUME_NONNULL_BEGIN

API_AVAILABLE(ios(13.0))
@interface PassportReaderResultsViewController : UIViewController

@property (nonatomic, readonly) NSArray<SBSDKNFCDatagroup*>*datagroups;

+ (instancetype)makeWith:(NSArray<SBSDKNFCDatagroup*>*)datagroups;

@end

NS_ASSUME_NONNULL_END
