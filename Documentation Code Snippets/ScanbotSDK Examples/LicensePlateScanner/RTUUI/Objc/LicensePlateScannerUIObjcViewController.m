//
//  LicensePlateScannerUIObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 04.06.21.
//

#import "LicensePlateScannerUIObjcViewController.h"
@import ScanbotSDK;

@interface LicensePlateScannerUIObjcViewController () <SBSDKUILicensePlateScannerViewControllerDelegate>

@end

@implementation LicensePlateScannerUIObjcViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // Start scanning here. Usually this is an action triggered by some button or menu.
    [self startScanning];
}

- (void)startScanning {

    // Create the default configuration object.
    SBSDKUILicensePlateScannerConfiguration *configuration = [SBSDKUILicensePlateScannerConfiguration defaultConfiguration];

    // Behavior configuration:
    // e.g. set the maximum number of accumulated frames before starting recognition.
    configuration.behaviorConfiguration.maximumNumberOfAccumulatedFrames = 5;

    // UI configuration:
    // e.g. configure various colors.
    configuration.uiConfiguration.topBarBackgroundColor = [UIColor redColor];
    configuration.uiConfiguration.topBarButtonsColor = [UIColor whiteColor];
    configuration.uiConfiguration.topBarButtonsInactiveColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];

    // Text configuration:
    // e.g. customize a UI element's text.
    configuration.textConfiguration.cancelButtonTitle = @"Cancel";

    // Present the recognizer view controller modally on this view controller.
    [SBSDKUILicensePlateScannerViewController presentOn:self
                                          configuration:configuration
                                               delegate:self];
}

- (void)licensePlateScanner:(SBSDKUILicensePlateScannerViewController *)controller
   didRecognizeLicensePlate:(SBSDKLicensePlateScannerResult *)result {
    // Process the scanned result.
}

@end
