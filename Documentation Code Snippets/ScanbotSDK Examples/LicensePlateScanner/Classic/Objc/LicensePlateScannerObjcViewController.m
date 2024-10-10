//
//  LicensePlateScannerObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 09.06.21.
//

#import "LicensePlateScannerObjcViewController.h"
@import ScanbotSDK;

@interface LicensePlateScannerObjcViewController () <SBSDKLicensePlateScannerViewControllerDelegate>

// The instance of the scanner view controller.
@property (strong, nonatomic) SBSDKLicensePlateScannerViewController *scannerViewController;

@end

@implementation LicensePlateScannerObjcViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Create the SBSDKLicensePlateScannerConfiguration object.
    SBSDKLicensePlateScannerConfiguration *configuration = [[SBSDKLicensePlateScannerConfiguration alloc] init];

    // Set the maximum number of accumulated frames before starting recognition.
    configuration.maximumNumberOfAccumulatedFrames = 5;

    // Create the SBSDKLicensePlateScannerViewController instance.
    self.scannerViewController = [[SBSDKLicensePlateScannerViewController alloc] initWithParentViewController:self
                                                                                                   parentView:self.view 
                                                                                                configuration:configuration 
                                                                                                     delegate:self];
}

- (void)licensePlateScannerViewController:(SBSDKLicensePlateScannerViewController * _Nonnull)controller 
                 didRecognizeLicensePlate:(SBSDKLicensePlateScannerResult * _Nonnull)licensePlateResult 
                                       on:(UIImage * _Nonnull)image { 

    // Process the recognized result.
}
@end
