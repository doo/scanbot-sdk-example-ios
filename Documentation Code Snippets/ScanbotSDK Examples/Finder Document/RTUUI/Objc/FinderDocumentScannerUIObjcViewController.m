//
//  FinderDocumentScannerUIObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 16.02.23.
//

#import "FinderDocumentScannerUIObjcViewController.h"
@import ScanbotSDK;

@interface FinderDocumentScannerUIObjcViewController() <SBSDKUIFinderDocumentScannerViewControllerDelegate>

@end

@implementation FinderDocumentScannerUIObjcViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Start scanning here. Usually this is an action triggered by some button or menu.
    [self startScanning];
}

-(void)startScanning {
    
    // Create the default configuration object.
    SBSDKUIFinderDocumentScannerConfiguration *configuration = [SBSDKUIFinderDocumentScannerConfiguration defaultConfiguration];

    // Behavior configuration:
    // e.g. customize the auto snapping delay.
    configuration.behaviorConfiguration.autoSnappingDelay = 0.8;

    // UI configuration:
    // e.g. configure various colors.
    configuration.uiConfiguration.topBarBackgroundColor = [UIColor redColor];
    configuration.uiConfiguration.topBarButtonsActiveColor = [UIColor whiteColor];
    configuration.uiConfiguration.topBarButtonsInactiveColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];

    // Text configuration:
    // e.g. customize a UI element's text.
    configuration.textConfiguration.cancelButtonTitle = @"Cancel";

    // Present the recognizer view controller modally on this view controller.
    [SBSDKUIFinderDocumentScannerViewController presentOn:self
                                            configuration:configuration
                                                 delegate:self];
}

- (void)finderScanningViewController:(SBSDKUIFinderDocumentScannerViewController *)viewController 
                       didFinishWith:(SBSDKDocument *)document {
    // Process the scanned document.
}

@end
