//
//  BarcodeUserGuidanceUI2ObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 28.12.23.
//

#import "BarcodeUserGuidanceUI2ObjcViewController.h"
@import ScanbotSDK;

@interface BarcodeUserGuidanceUI2ObjcViewController ()

@end

@implementation BarcodeUserGuidanceUI2ObjcViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Start scanning here. Usually this is an action triggered by some button or menu.
    [self startScanning];
}

- (void)startScanning {
    
    // Create the default configuration object.
    SBSDKUI2BarcodeScannerConfiguration *configuration = [[SBSDKUI2BarcodeScannerConfiguration alloc] init];
    
    // Retrieve the instance of the user guidance from the configuration object.
    SBSDKUI2UserGuidanceConfiguration *userGuidance = configuration.userGuidance;
    
    // Hide/unhide the user guidance.
    userGuidance.visible = YES;
    
    // Configure the title.
    userGuidance.title.text = @"Move the finder over a barcode";
    userGuidance.title.color = [[SBSDKUI2Color alloc] initWithColorString:@"#FFFFFF"];
    
    // Configure the background.
    userGuidance.background.fillColor = [[SBSDKUI2Color alloc] initWithColorString:@"#7A000000"];
    
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
