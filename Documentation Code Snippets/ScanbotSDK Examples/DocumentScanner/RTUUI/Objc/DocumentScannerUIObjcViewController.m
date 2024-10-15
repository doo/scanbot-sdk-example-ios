//
//  DocumentScannerUIObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 10.06.21.
//

#import "DocumentScannerUIObjcViewController.h"
@import ScanbotSDK;

@interface DocumentScannerUIObjcViewController () <SBSDKUIDocumentScannerViewControllerDelegate>

@end

@implementation DocumentScannerUIObjcViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // Start scanning here. Usually this is an action triggered by some button or menu.
    [self startScanning];
}

- (void)startScanning {

    // Create the default configuration object.
    SBSDKUIDocumentScannerConfiguration *configuration = [SBSDKUIDocumentScannerConfiguration defaultConfiguration];

    // Behavior configuration:
    // e.g. enable multi page mode to scan several documents before processing the result.
    configuration.behaviorConfiguration.isMultiPageEnabled = YES;

    // UI configuration:
    // e.g. configure various colors.
    configuration.uiConfiguration.topBarBackgroundColor = [UIColor redColor];
    configuration.uiConfiguration.topBarButtonsActiveColor = [UIColor whiteColor];
    configuration.uiConfiguration.topBarButtonsInactiveColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];

    // Text configuration:
    // e.g. customize a UI element's text.
    configuration.textConfiguration.cancelButtonTitle = @"Cancel";

    // Present the recognizer view controller modally on this view controller.
    [SBSDKUIDocumentScannerViewController presentOn:self
                                      configuration:configuration
                                           delegate:self];
}

- (void)scanningViewController:(SBSDKUIDocumentScannerViewController *)viewController
         didFinishWithDocument:(SBSDKDocument *)document {
    // Process the scanned document.
}

@end
