//
//  ActionBarConfigurationUI2ObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 21.12.23.
//

#import "ActionBarConfigurationUI2ObjcViewController.h"
@import ScanbotSDK;

@interface ActionBarConfigurationUI2ObjcViewController ()

@end

@implementation ActionBarConfigurationUI2ObjcViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Start scanning here. Usually this is an action triggered by some button or menu.
    [self startScanning];
}

- (void)startScanning {
    
    // Create the default configuration object.
    SBSDKUI2BarcodeScannerConfiguration *configuration = [[SBSDKUI2BarcodeScannerConfiguration alloc] init];
    
    // Retrieve the instance of the action bar from the configuration object.
    SBSDKUI2ActionBarConfiguration *actionBar = [configuration actionBar];
    
    // Hide/unhide the flash button.
    actionBar.flashButton.visible = YES;
    
    // Configure the inactive state of the flash button.
    actionBar.flashButton.backgroundColor = [[SBSDKUI2Color alloc] initWithColorString:@"#7A000000"];
    actionBar.flashButton.foregroundColor = [[SBSDKUI2Color alloc] initWithColorString:@"#FFFFFF"];
    
    // Configure the active state of the flash button.
    actionBar.flashButton.activeBackgroundColor = [[SBSDKUI2Color alloc] initWithColorString:@"#FFCE5C"];
    actionBar.flashButton.activeForegroundColor = [[SBSDKUI2Color alloc] initWithColorString:@"#000000"];
    
    // Hide/unhide the zoom button.
    actionBar.zoomButton.visible = YES;
    
    // Configure the zoom button.
    actionBar.zoomButton.backgroundColor = [[SBSDKUI2Color alloc] initWithColorString:@"#7A000000"];
    actionBar.zoomButton.foregroundColor = [[SBSDKUI2Color alloc] initWithColorString:@"#FFFFFF"];
    
    // Hide/unhide the flip camera button.
    actionBar.flipCameraButton.visible = YES;
    
    // Configure the flip camera button.
    actionBar.flipCameraButton.backgroundColor = [[SBSDKUI2Color alloc] initWithColorString:@"#7A000000"];
    actionBar.flipCameraButton.foregroundColor = [[SBSDKUI2Color alloc] initWithColorString:@"#FFFFFF"];
    
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
