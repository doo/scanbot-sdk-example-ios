//
//  LocalizationUI2ObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Sebastian Husche on 14.05.24.
//

#import "LocalizationUI2ObjcViewController.h"
@import ScanbotSDK;

@interface LocalizationUI2ObjcViewController ()

@end

@implementation LocalizationUI2ObjcViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Start scanning here. Usually this is an action triggered by some button or menu.
    [self startScanning];
}

- (void)startScanning {
    
    // Create the default configuration object.
    SBSDKUI2BarcodeScannerConfiguration *configuration = [[SBSDKUI2BarcodeScannerConfiguration alloc] init];
    
    // Retrieve the instance of the localization from the configuration object.
    SBSDKUI2BarcodeTextLocalization  *localization = configuration.localization;

    // Configure the strings.
    localization.barcodeInfoMappingErrorStateCancelButton = NSLocalizedString(@"barcode.infomapping.cancel", comment: nil);
    localization.cameraPermissionCloseButton = NSLocalizedString(@"camera.permission.close", comment: nil);

    // Set the localization in the barcode scanner configuration object.
    configuration.localization = localization;
    
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
