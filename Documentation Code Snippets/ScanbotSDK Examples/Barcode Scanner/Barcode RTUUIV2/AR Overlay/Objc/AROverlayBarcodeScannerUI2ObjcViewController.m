//
//  AROverlayBarcodeScannerUI2ObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 19.12.23.
//

#import "AROverlayBarcodeScannerUI2ObjcViewController.h"
@import ScanbotSDK;

@interface AROverlayBarcodeScannerUI2ObjcViewController ()

@end

@implementation AROverlayBarcodeScannerUI2ObjcViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Start scanning here. Usually this is an action triggered by some button or menu.
    [self startScanning];
}

- (void)startScanning {
    
    // Create the default configuration object.
    SBSDKUI2BarcodeScannerConfiguration *configuration = [[SBSDKUI2BarcodeScannerConfiguration alloc] init];
    
    // Configure the usecase.
    SBSDKUI2MultipleScanningMode *usecase = [[SBSDKUI2MultipleScanningMode alloc] init];
    usecase.mode = SBSDKUI2MultipleBarcodesScanningModeUnique;
    usecase.sheet.mode = SBSDKUI2SheetModeCollapsedSheet;
    usecase.sheet.collapsedVisibleHeight = SBSDKUI2CollapsedVisibleHeightSmall;
    
    // Configure AR Overlay.
    usecase.arOverlay.visible = YES;
    usecase.arOverlay.automaticSelectionEnabled = NO;
    
    // Set the configured usecase.
    configuration.useCase = usecase;
    
    // Create and set an array of accepted barcode formats.
    NSArray<SBSDKUI2BarcodeFormat *> *acceptedBarcodeFormats = [SBSDKUI2BarcodeFormat twoDFormats];
    configuration.recognizerConfiguration.barcodeFormats = acceptedBarcodeFormats;
    
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
