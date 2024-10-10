//
//  EHICScannerUIObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 25.05.21.
//

#import "EHICScannerUIObjcViewController.h"
@import ScanbotSDK;

@interface EHICScannerUIObjcViewController () <SBSDKUIHealthInsuranceCardScannerViewControllerDelegate>

@end

@implementation EHICScannerUIObjcViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // Start scanning here. Usually this is an action triggered by some button or menu.
    [self startScanning];
}

- (void)startScanning {

    // Create the default configuration object.
    SBSDKUIHealthInsuranceCardScannerConfiguration *configuration = [SBSDKUIHealthInsuranceCardScannerConfiguration defaultConfiguration];

    // Behavior configuration:
    // e.g. turn on the flashlight.
    configuration.behaviorConfiguration.isFlashEnabled = YES;

    // UI configuration:
    // e.g. configure various colors.
    configuration.uiConfiguration.topBarButtonsColor = [UIColor whiteColor];
    configuration.uiConfiguration.topBarBackgroundColor = [UIColor redColor];

    // Text configuration:
    // e.g. customize some UI elements' text.
    configuration.textConfiguration.flashButtonTitle = @"Flash";
    configuration.textConfiguration.cancelButtonTitle = @"Cancel";

    // Present the recognizer view controller modally on this view controller.
    [SBSDKUIHealthInsuranceCardScannerViewController presentOn:self
                                                 configuration:configuration
                                                      delegate:self];
}

- (void)healthInsuranceCardDetectionViewController:(SBSDKUIHealthInsuranceCardScannerViewController *)viewController
                                     didDetectCard:(SBSDKHealthInsuranceCardRecognitionResult *)card {
    // Process the detected card.
}

@end
