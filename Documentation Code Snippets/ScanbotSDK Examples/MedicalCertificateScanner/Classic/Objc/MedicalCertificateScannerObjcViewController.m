//
//  MedicalCertificateScannerObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 10.02.22.
//

#import "MedicalCertificateScannerObjcViewController.h"
@import ScanbotSDK;

@interface MedicalCertificateScannerObjcViewController () <SBSDKMedicalCertificateScannerViewControllerDelegate>

// The instance of the scanner view controller.
@property (strong, nonatomic) SBSDKMedicalCertificateScannerViewController *scannerViewController;

@end

@implementation MedicalCertificateScannerObjcViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Create the SBSDKMedicalCertificateScannerViewController instance.
    self.scannerViewController =
    [[SBSDKMedicalCertificateScannerViewController alloc] initWithParentViewController:self
                                                                            parentView:self.view
                                                                              delegate:self];
}

- (void)medicalCertificateScannerViewController:(SBSDKMedicalCertificateScannerViewController *)controller
                 didRecognizeMedicalCertificate:(SBSDKMedicalCertificateRecognizerResult *)result {
    // Process the recognized result.
}

@end
