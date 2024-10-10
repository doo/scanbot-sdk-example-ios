//
//  PaletteUI2ObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 08.01.24.
//

#import <Foundation/Foundation.h>

#import "PaletteUI2ObjcViewController.h"
@import ScanbotSDK;

@interface PaletteUI2ObjcViewController ()

@end

@implementation PaletteUI2ObjcViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Start scanning here. Usually this is an action triggered by some button or menu.
    [self startScanning];
}

- (void)startScanning {
    
    // Create the default configuration object.
    SBSDKUI2BarcodeScannerConfiguration *configuration = [[SBSDKUI2BarcodeScannerConfiguration alloc] init];
    
    // Retrieve the instance of the palette from the configuration object.
    SBSDKUI2Palette *palette = configuration.palette;
    
    // Configure the colors.
    // The palette already has the default colors set, so you don't have to always set all the colors.
    palette.sbColorPrimary = [[SBSDKUI2Color alloc] initWithColorString:@"#C8193C"];
    palette.sbColorPrimaryDisabled = [[SBSDKUI2Color alloc] initWithColorString:@"#F5F5F5"];
    palette.sbColorNegative = [[SBSDKUI2Color alloc] initWithColorString:@"#FF3737"];
    palette.sbColorPositive = [[SBSDKUI2Color alloc] initWithColorString:@"#4EFFB4"];
    palette.sbColorWarning = [[SBSDKUI2Color alloc] initWithColorString:@"#FFCE5C"];
    palette.sbColorSecondary = [[SBSDKUI2Color alloc] initWithColorString:@"#FFEDEE"];
    palette.sbColorSecondaryDisabled = [[SBSDKUI2Color alloc] initWithColorString:@"#F5F5F5"];
    palette.sbColorOnPrimary = [[SBSDKUI2Color alloc] initWithColorString:@"#FFFFFF"];
    palette.sbColorOnSecondary = [[SBSDKUI2Color alloc] initWithColorString:@"#C8193C"];
    palette.sbColorSurface = [[SBSDKUI2Color alloc] initWithColorString:@"#FFFFFF"];
    palette.sbColorOutline = [[SBSDKUI2Color alloc] initWithColorString:@"#EFEFEF"];
    palette.sbColorOnSurfaceVariant = [[SBSDKUI2Color alloc] initWithColorString:@"#707070"];
    palette.sbColorOnSurface = [[SBSDKUI2Color alloc] initWithColorString:@"#000000"];
    palette.sbColorSurfaceLow = [[SBSDKUI2Color alloc] initWithColorString:@"#26000000"];
    palette.sbColorSurfaceHigh = [[SBSDKUI2Color alloc] initWithColorString:@"#7A000000"];
    palette.sbColorModalOverlay = [[SBSDKUI2Color alloc] initWithColorString:@"#A3000000"];
    
    // Set the palette in the barcode scanner configuration object.
    configuration.palette = palette;
    
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
