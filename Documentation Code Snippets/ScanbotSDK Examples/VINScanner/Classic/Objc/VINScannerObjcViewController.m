//
//  VINScannerObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 04.08.23.
//

#import "VINScannerObjcViewController.h"
@import ScanbotSDK;

@interface VINScannerObjcViewController () <SBSDKVINScannerViewControllerDelegate>

// The instance of the scanner view controller.
@property (strong, nonatomic) SBSDKVINScannerViewController *scannerViewController;

@end

@implementation VINScannerObjcViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Create the default SBSDKVehicleIdentificationNumberScannerConfiguration object.
    SBSDKVehicleIdentificationNumberScannerConfiguration *configuration = [SBSDKVehicleIdentificationNumberScannerConfiguration defaultConfiguration];

    // Create the SBSDKVINScannerViewController instance.
    self.scannerViewController = [[SBSDKVINScannerViewController alloc] initWithParentViewController:self
                                                                                          parentView:self.view
                                                                                       configuration:configuration
                                                                                            delegate:self];
}

- (void)vinScannerViewController:(SBSDKVINScannerViewController *)controller
              didScanValidResult:(SBSDKVehicleIdentificationNumberScannerResult *)result {
    // Process the result.
}

@end
