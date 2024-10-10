//
//  VINScannerUIObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 04.08.23.
//

#import "VINScannerUIObjcViewController.h"
@import ScanbotSDK;

@interface VINScannerUIObjcViewController () <SBSDKUIVINScannerViewControllerDelegate>

@end

@implementation VINScannerUIObjcViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // Start scanning here. Usually this is an action triggered by some button or menu.
    [self startScanning];
}

- (void)startScanning {

    // Create the default configuration object.
    SBSDKUIVINScannerConfiguration *configuration = [SBSDKUIVINScannerConfiguration defaultConfiguration];

    // Behavior configuration:
    // e.g. set the maximum number of accumulated frames.
    configuration.behaviorConfiguration.maximumNumberOfAccumulatedFrames = 4;

    // UI configuration:
    // e.g. configure various colors.
    configuration.uiConfiguration.topBarBackgroundColor = [UIColor redColor];
    configuration.uiConfiguration.topBarButtonsColor = [UIColor whiteColor];

    // Text configuration:
    // e.g. customize a UI element's text.
    configuration.textConfiguration.guidanceText = @"Scan Vin";
    configuration.textConfiguration.cancelButtonTitle = @"Cancel";

    // Present the scanner view controller modally on this view controller.
    [SBSDKUIVINScannerViewController presentOn:self
                                 configuration:configuration
                                      delegate:self];
}

- (void)vinScannerViewController:(SBSDKUIVINScannerViewController *)viewController
             didFinishWithResult:(SBSDKVehicleIdentificationNumberScannerResult *)result {
    // Process the result.
}

@end
