//
//  PDFViewController.h
//  ScanbotSDKDemo
//
//  Created by Sebastian Husche on 24.06.15.
//  Copyright (c) 2015 doo GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDFViewController : UIViewController

@property (nonatomic, strong) NSURL *pdfURL;

+ (PDFViewController *)pdfControllerWithURL:(NSURL *)pdfURL;

@end
