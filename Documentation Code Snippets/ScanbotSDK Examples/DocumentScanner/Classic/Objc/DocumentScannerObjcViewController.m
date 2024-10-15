//
//  DocumentScannerObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 10.06.21.
//

#import "DocumentScannerObjcViewController.h"
@import ScanbotSDK;

@interface DocumentScannerObjcViewController () <SBSDKDocumentScannerViewControllerDelegate>

// The instance of the scanner view controller.
@property SBSDKDocumentScannerViewController *scannerViewController;

@end

@implementation DocumentScannerObjcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create the SBSDKScannerViewController instance.
    self.scannerViewController = [[SBSDKDocumentScannerViewController alloc] initWithParentViewController:self
                                                                                               parentView:self.view
                                                                                                 delegate:self];
}

- (void)documentScannerViewController:(nonnull SBSDKDocumentScannerViewController *)controller
                 didSnapDocumentImage:(nonnull UIImage *)documentImage
                              onImage:(nonnull UIImage *)originalImage
                           withResult:(nullable SBSDKDocumentDetectorResult *)result autoSnapped:(BOOL)autoSnapped {
    // Process the detected document.
}

@end
