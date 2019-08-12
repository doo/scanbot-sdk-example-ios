//
//  BarCodeTypesListViewController.h
//  SBSDK Internal Demo
//
//  Created by Andrew Petrus on 13.05.19.
//  Copyright © 2019 doo GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BarCodeTypesListViewControllerDelegate <NSObject>

- (void)barCodeTypesSelectionChanged:(NSArray<NSNumber *> *)newTypes;

@end

@interface BarCodeTypesListViewController : UITableViewController

@property (nonatomic, weak) id<BarCodeTypesListViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray<NSNumber *> *selectedBarCodeTypes;

@end

NS_ASSUME_NONNULL_END
