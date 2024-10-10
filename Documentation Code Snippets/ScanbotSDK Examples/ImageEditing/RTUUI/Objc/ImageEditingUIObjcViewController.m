//
//  ImageEditingUIObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 09.09.21.
//

#import "ImageEditingUIObjcViewController.h"
@import ScanbotSDK;

@interface ImageEditingUIObjcViewController () <SBSDKUICroppingViewControllerDelegate>

// Page to edit.
@property (strong, nonatomic) SBSDKDocumentPage *editingPage;

@end

@implementation ImageEditingUIObjcViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // Create the default configuration object.
    SBSDKUICroppingScreenConfiguration * configuration = [SBSDKUICroppingScreenConfiguration defaultConfiguration];

    // Behavior configuration:
    // e.g disable the rotation feature.
    configuration.behaviorConfiguration.isRotationEnabled = NO;

    // UI configuration:
    // e.g. configure various colors.
    configuration.uiConfiguration.topBarBackgroundColor = [UIColor redColor];
    configuration.uiConfiguration.topBarButtonsColor = [UIColor whiteColor];

    // Text configuration:
    // e.g. customize a UI element's text
    configuration.textConfiguration.cancelButtonTitle = @"Cancel";

    // Present the recognizer view controller modally on this view controller.
    [SBSDKUICroppingViewController presentOn:self
                                        page:self.editingPage
                               configuration:configuration
                                    delegate:self];
}

- (void)croppingViewController:(SBSDKUICroppingViewController *)viewController didFinish:(SBSDKDocumentPage *)changedPage {
    // Process the edited page and dismiss the editing screen
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
