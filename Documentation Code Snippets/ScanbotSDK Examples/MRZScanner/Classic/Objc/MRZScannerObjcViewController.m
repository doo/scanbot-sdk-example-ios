//
//  MRZScannerObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 25.10.21.
//

#import "MRZScannerObjcViewController.h"
@import ScanbotSDK;

@interface MRZScannerObjcViewController () <SBSDKMRZScannerViewControllerDelegate>

// The instance of the recognition view controller.
@property (nonatomic, strong) SBSDKMRZScannerViewController *scannerViewController;

@end

@implementation MRZScannerObjcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create the SBSDKMRZScannerViewController instance.
    self.scannerViewController = [[SBSDKMRZScannerViewController alloc] initWithParentViewController:self
                                                                                          parentView:self.view
                                                                                            delegate:self];
}

- (void)mrzScannerController:(nonnull SBSDKMRZScannerViewController *)controller
                didDetectMRZ:(nonnull SBSDKMachineReadableZoneRecognizerResult *)result {
    // Process the recognized result.
}

@end
