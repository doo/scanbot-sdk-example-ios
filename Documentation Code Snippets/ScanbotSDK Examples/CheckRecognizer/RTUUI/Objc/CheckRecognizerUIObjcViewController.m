//
//  CheckRecognizerUIObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 27.04.22.
//

#import "CheckRecognizerUIObjcViewController.h"
@import ScanbotSDK;

@interface CheckRecognizerUIObjcViewController () <SBSDKUICheckRecognizerViewControllerDelegate>

@end

@implementation CheckRecognizerUIObjcViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Start scanning here. Usually this is an action triggered by some button or menu.
    [self startScanning];
}

- (void)startScanning {
    
    // Create the default configuration object.
    SBSDKUICheckRecognizerConfiguration *configuration = [SBSDKUICheckRecognizerConfiguration defaultConfiguration];
    
    // Behavior configuration:
    // e.g. disable capturing the photo to recognize on live video stream
    configuration.behaviorConfiguration.captureHighResolutionImage = NO;
    
    // UI configuration:
    // e.g. configure various colors.
    configuration.uiConfiguration.topBarBackgroundColor = [UIColor redColor];
    configuration.uiConfiguration.topBarButtonsColor = [UIColor whiteColor];
    
    // Text configuration:
    // e.g. customize UI element's text.
    configuration.textConfiguration.cancelButtonTitle = @"Cancel";
    
    // Present the recognizer view controller modally on this view controller.
    [SBSDKUICheckRecognizerViewController presentOn:self
                                      configuration:configuration
                                           delegate:self];
}

- (void)checkRecognizerViewController:(SBSDKUICheckRecognizerViewController *)viewController
                    didRecognizeCheck:(SBSDKCheckRecognizerResult *)result {
    // Process the recognized result.
}

- (void)checkRecognizerViewControllerDidCancel:(nonnull SBSDKUICheckRecognizerViewController *)viewController {
    // Handle dismissing of the recognizer view controller.
}

@end
