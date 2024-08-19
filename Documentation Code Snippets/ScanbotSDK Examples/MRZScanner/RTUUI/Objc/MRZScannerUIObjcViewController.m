//
//  MRZScannerUIObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 25.05.21.
//

#import "MRZScannerUIObjcViewController.h"
@import ScanbotSDK;

@interface MRZScannerUIObjcViewController () <SBSDKUIMRZScannerViewControllerDelegate>

@end

@implementation MRZScannerUIObjcViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // Start scanning here. Usually this is an action triggered by some button or menu.
    [self startScanning];
}

- (void)startScanning {

    // Create the default configuration object.
    SBSDKUIMRZScannerConfiguration *configuration = [SBSDKUIMRZScannerConfiguration defaultConfiguration];

    // Behavior configuration:
    // e.g. enable a beep sound on successful detection.
    configuration.behaviorConfiguration.isSuccessBeepEnabled = YES;

    // UI configuration:
    // e.g. configure various colors and the finder's aspect ratio.
    configuration.uiConfiguration.topBarButtonsColor = [UIColor whiteColor];
    configuration.uiConfiguration.topBarBackgroundColor = [UIColor redColor];
    configuration.uiConfiguration.finderAspectRatio = [[SBSDKAspectRatio alloc] initWithWidth:1 andHeight:0.25];

    // Text configuration:
    // e.g. customize some UI elements' text.
    configuration.textConfiguration.cancelButtonTitle = @"Cancel";
    configuration.textConfiguration.flashButtonTitle = @"Flash";

    // Present the recognizer view controller modally on this view controller.
    [SBSDKUIMRZScannerViewController presentOn:self
                                 configuration:configuration
                                      delegate:self];
}

- (void)mrzDetectionViewController:(SBSDKUIMRZScannerViewController *)viewController
                         didDetect:(SBSDKMachineReadableZoneRecognizerResult *)zone {
    // Process the detected result.
}

@end
