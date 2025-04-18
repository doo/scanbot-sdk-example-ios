//
//  BarcodesSheetModeUI2ObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 28.12.23.
//

#import "BarcodesSheetModeUI2ObjcViewController.h"
@import ScanbotSDK;

@interface BarcodesSheetModeUI2ObjcViewController ()

@end

@implementation BarcodesSheetModeUI2ObjcViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Start scanning here. Usually this is an action triggered by some button or menu.
    [self startScanning];
}

- (void)startScanning {
    
    // Create the default configuration object.
    SBSDKUI2BarcodeScannerConfiguration *configuration = [[SBSDKUI2BarcodeScannerConfiguration alloc] init];
    
    // Initialize the multi scan usecase.
    SBSDKUI2MultipleScanningMode *multiUsecase = [[SBSDKUI2MultipleScanningMode alloc] init];
    
    // Set the sheet mode of the barcodes preview.
    multiUsecase.sheet.mode = SBSDKUI2SheetModeCollapsedSheet;
    
    // Set the height of the collapsed sheet.
    multiUsecase.sheet.collapsedVisibleHeight = SBSDKUI2CollapsedVisibleHeightLarge;
    
    // Configure the submit button.
    multiUsecase.sheetContent.submitButton.text = @"Submit";
    multiUsecase.sheetContent.submitButton.foreground.color = [[SBSDKUI2Color alloc] initWithColorString:@"#000000"];
    
    // Set the configured usecase.
    configuration.useCase = multiUsecase;
    
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
