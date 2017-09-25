//
//  TextViewController.h
//  PayFormScannerDemo
//
//  Created by Sebastian Husche on 24.06.15.
//  Copyright (c) 2015 doo GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextViewController : UIViewController

@property (nonatomic, strong) NSString *textToDisplay;

+ (TextViewController *)textControllerWithText:(NSString *)text;

@end
