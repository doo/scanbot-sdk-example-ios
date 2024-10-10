//
//  FindAndPickBarcodeScannerUIObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 25.03.24.
//

#import "FindAndPickBarcodeScannerUIObjcViewController.h"
@import ScanbotSDK;

@interface FindAndPickBarcodeScannerUIObjcViewController ()

@end

@implementation FindAndPickBarcodeScannerUIObjcViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Start scanning here. Usually this is an action triggered by some button or menu.
    [self startScanning];
}

- (void)startScanning {
    
    // Create the default configuration object.
    SBSDKUI2BarcodeScannerConfiguration *configuration = [[SBSDKUI2BarcodeScannerConfiguration alloc] init];
    
    // Initialize the find and pick scan usecase.
    SBSDKUI2FindAndPickScanningMode *usecase = [[SBSDKUI2FindAndPickScanningMode alloc] init];
    
    // Configure AR Overlay.
    usecase.arOverlay.visible = YES;
    
    // Enable/Disable the automatic selection.
    usecase.arOverlay.automaticSelectionEnabled = NO;
    
    // Enable/Disable the swipe to delete.
    usecase.sheetContent.swipeToDelete.enabled = YES;
    
    // Enable/Disable allow partial scan.
    usecase.allowPartialScan = YES;
    
    // Create the expected barcodes.
    SBSDKUI2ExpectedBarcode *expectedCode1 = [[SBSDKUI2ExpectedBarcode alloc] initWithBarcodeValue:@"123456"
                                                                                             title:nil
                                                                                             image:@"Image_URL"
                                                                                             count:4];
    SBSDKUI2ExpectedBarcode *expectedCode2 = [[SBSDKUI2ExpectedBarcode alloc] initWithBarcodeValue:@"SCANBOT"
                                                                                             title:nil
                                                                                             image:@"Image_URL"
                                                                                             count:3];
    // Set the expected barcodes.
    usecase.expectedBarcodes = @[expectedCode1, expectedCode2];
    
    // Set the configured usecase.
    configuration.useCase = usecase;
    
    // Present the recognizer view controller modally on this view controller.
    [SBSDKUI2BarcodeScannerViewController presentOn:self
                                      configuration:configuration
                                            handler:^(SBSDKUI2BarcodeScannerViewController * _Nonnull controller,
                                                      BOOL cancelled,
                                                      NSError * _Nullable error,
                                                      SBSDKUI2BarcodeScannerResult * _Nullable result) {
        
        // Completion handler to process the result.
        // The `cancelled` parameter indicates if the cancel button was tapped.
        
        [controller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
