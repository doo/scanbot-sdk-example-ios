//
//  MedicalCertificateScannerUIObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 26.05.21.
//

#import "MedicalCertificateScannerUIObjcViewController.h"
@import ScanbotSDK;

@interface MedicalCertificateScannerUIObjcViewController () <SBSDKUIMedicalCertificateScannerViewControllerDelegate>

@end

@implementation MedicalCertificateScannerUIObjcViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // Start scanning here. Usually this is an action triggered by some button or menu.
    [self startScanning];
}

- (void)startScanning {

    // Create the default configuration object.
    SBSDKUIMedicalCertificateScannerConfiguration *configuration = [SBSDKUIMedicalCertificateScannerConfiguration defaultConfiguration];

    // Behavior configuration:
    // e.g. disable recognition of patient's personal information.
    configuration.behaviorConfiguration.isPatientInfoExtracted = NO;

    // UI configuration:
    // e.g. configure various colors.
    configuration.uiConfiguration.topBarBackgroundColor = [UIColor redColor];
    configuration.uiConfiguration.topBarButtonsColor = [UIColor whiteColor];

    // Text configuration:
    // e.g. customize UI element's text.
    configuration.textConfiguration.cancelButtonTitle = @"Cancel";

    // Present the recognizer view controller modally on this view controller.
    [SBSDKUIMedicalCertificateScannerViewController presentOn:self
                                                configuration:configuration
                                                     delegate:self];
}

- (void)medicalScannerViewController:(SBSDKUIMedicalCertificateScannerViewController *)viewController
                 didFinishWithResult:(SBSDKMedicalCertificateRecognizerResult *)result {
    // Process the scanned result.
}


- (void)medicalScannerViewControllerDidCancel:(SBSDKUIMedicalCertificateScannerViewController *)viewController {
    // Handle canceling the scanner screen.
}

@end
