//
//  TopBarBarcodeUI2ObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 28.12.23.
//

#import "TopBarBarcodeUI2ObjcViewController.h"
@import ScanbotSDK;

@interface TopBarBarcodeUI2ObjcViewController ()

@end

@implementation TopBarBarcodeUI2ObjcViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Start scanning here. Usually this is an action triggered by some button or menu.
    [self startScanning];
}

- (void)startScanning {
    
    // Create the default configuration object.
    SBSDKUI2BarcodeScannerConfiguration *configuration = [[SBSDKUI2BarcodeScannerConfiguration alloc] init];
    
    // Configure the top bar.
    
    // Set the top bar mode.
    configuration.topBar.mode = SBSDKUI2TopBarModeGradient;
    
    // Set the background color which will be used as a gradient.
    configuration.topBar.backgroundColor = [[SBSDKUI2Color alloc] initWithColorString:@"#C8193C"];
    
    // Set the status bar mode.
    configuration.topBar.statusBarMode = SBSDKUI2StatusBarModeLight;
    
    // Configure the cancel button.
    configuration.topBar.cancelButton.text = @"Cancel";
    configuration.topBar.cancelButton.foreground.color = [[SBSDKUI2Color alloc] initWithColorString:@"#FFFFFF"];
    
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
