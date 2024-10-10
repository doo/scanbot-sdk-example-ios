//
//  SingleBarcodeScannerUIObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 19.12.23.
//

#import "SingleBarcodeScannerUI2ObjcViewController.h"
@import ScanbotSDK;

@interface SingleBarcodeScannerUI2ObjcViewController ()

@end

@implementation SingleBarcodeScannerUI2ObjcViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Start scanning here. Usually this is an action triggered by some button or menu.
    [self startScanning];
}

- (void)startScanning {
    
    // Create the default configuration object.
    SBSDKUI2BarcodeScannerConfiguration *configuration = [[SBSDKUI2BarcodeScannerConfiguration alloc] init];
    
    // Initialize the single scan usecase.
    SBSDKUI2SingleScanningMode *singleUsecase = [[SBSDKUI2SingleScanningMode alloc] init];
    
    // Enable the confirmation sheet.
    singleUsecase.confirmationSheetEnabled = YES;
    singleUsecase.sheetColor = [[SBSDKUI2Color alloc] initWithColorString:@"#FFFFFF"];
    
    // Hide/unhide the barcode image.
    singleUsecase.barcodeImageVisible = YES;
    
    // Configure the barcode title of the confirmation sheet.
    singleUsecase.barcodeTitle.visible = YES;
    singleUsecase.barcodeTitle.color = [[SBSDKUI2Color alloc] initWithColorString:@"#000000"];
    
    // Configure the barcode subtitle of the confirmation sheet.
    singleUsecase.barcodeSubtitle.visible = YES;
    singleUsecase.barcodeSubtitle.color = [[SBSDKUI2Color alloc] initWithColorString:@"#000000"];
    
    // Configure the cancel button of the confirmation sheet.
    singleUsecase.cancelButton.text = @"Close";
    singleUsecase.cancelButton.foreground.color = [[SBSDKUI2Color alloc] initWithColorString:@"#C8193C"];
    singleUsecase.cancelButton.background.fillColor = [[SBSDKUI2Color alloc] initWithColorString:@"#00000000"];
    
    // Configure the submit button of the confirmation sheet.
    singleUsecase.submitButton.text = @"Submit";
    singleUsecase.submitButton.foreground.color = [[SBSDKUI2Color alloc] initWithColorString:@"#FFFFFF"];
    singleUsecase.submitButton.background.fillColor = [[SBSDKUI2Color alloc] initWithColorString:@"#C8193C"];
    
    // Set the configured usecase.
    configuration.useCase = singleUsecase;
    
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
