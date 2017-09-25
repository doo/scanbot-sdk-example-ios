//
//  DocumentDemoNavigationViewController.m
//  PayFormScannerDemo
//
//  Created by Sebastian Husche on 24.06.15.
//  Copyright (c) 2015 doo GmbH. All rights reserved.
//

#import "DocumentDemoNavigationViewController.h"

@interface DocumentDemoNavigationViewController ()

@end

@implementation DocumentDemoNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
