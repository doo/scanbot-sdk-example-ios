//
//  GenericTextLineRecognizerUIObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 07.06.21.
//

#import "GenericTextLineRecognizerUIObjcViewController.h"
@import ScanbotSDK;

@interface GenericTextLineRecognizerUIObjcViewController () <SBSDKUITextDataScannerViewControllerDelegate>

@end

@implementation GenericTextLineRecognizerUIObjcViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // Start scanning here. Usually this is an action triggered by some button or menu.
    [self startScanning];
}

- (void)startScanning {

    // Create the default configuration object.
    SBSDKUITextDataScannerConfiguration *configuration = [SBSDKUITextDataScannerConfiguration defaultConfiguration];

    // Behavior configuration:
    // e.g. enable highlighting of the detected word boxes.
    configuration.behaviorConfiguration.wordBoxHighlightEnabled = YES;

    // UI configuration:
    // e.g. configure various colors.
    configuration.uiConfiguration.topBarBackgroundColor = [UIColor redColor];
    configuration.uiConfiguration.topBarButtonsColor = [UIColor whiteColor];

    // Text configuration:
    // e.g. customize a UI element's text.
    configuration.textConfiguration.cancelButtonTitle = @"Cancel";

    // Create the data scanner step.
    SBSDKUITextDataScannerStep *step = [[SBSDKUITextDataScannerStep alloc] init];

    // Set the finder's unzoomed height.
    step.unzoomedFinderHeight = 100;

    // Set the aspect ratio.
    step.aspectRatio = [[SBSDKAspectRatio alloc] initWithWidth:4.0 andHeight:1.0];

    // Set the guidance text.
    step.guidanceText = @"Scan a document";

    configuration.behaviorConfiguration.recognitionStep = step;
    // Present the recognizer view controller modally on this view controller.
    [SBSDKUITextDataScannerViewController presentOn:self
                                      configuration:configuration
                                           delegate:self];
}

- (void)textLineRecognizerViewController:(nonnull SBSDKUITextDataScannerViewController *)viewController
                           didFinishStep:(nonnull SBSDKUITextDataScannerStep *)step
                              withResult:(nonnull SBSDKUITextDataScannerStepResult *)result {
    // Process the recognized result.
}

@end
