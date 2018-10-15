//
//  PDFViewController.h
//  ScanbotSDKDemo
//
//  Created by Sebastian Husche on 24.06.15.
//  Copyright (c) 2015 doo GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemoPDFViewController : UIViewController

@property (nonatomic, strong) NSURL *pdfURL;

+ (DemoPDFViewController *)pdfControllerWithURL:(NSURL *)pdfURL;

@end
