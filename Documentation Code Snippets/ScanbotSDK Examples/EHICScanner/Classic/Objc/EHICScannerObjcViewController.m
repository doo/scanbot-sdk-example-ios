//
//  EHICScannerObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 25.10.21.
//

#import "EHICScannerObjcViewController.h"
@import ScanbotSDK;

@interface EHICScannerObjcViewController () <SBSDKHealthInsuranceCardScannerViewControllerDelegate>

// The instance of the recognition view controller.
@property (nonatomic, strong) SBSDKHealthInsuranceCardScannerViewController *scannerController;

@end

@implementation EHICScannerObjcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create the SBSDKHealthInsuranceCardScannerViewController instance.
    self.scannerController =
    [[SBSDKHealthInsuranceCardScannerViewController alloc] initWithParentViewController:self
                                                                             parentView:self.view
                                                                               delegate:self];
}

- (void)healthInsuranceCardScannerViewController:(nonnull SBSDKHealthInsuranceCardScannerViewController *)viewController
                      didScanHealthInsuranceCard:(nonnull SBSDKHealthInsuranceCardRecognitionResult *)card {
    // Process the recognized result.
}

@end
