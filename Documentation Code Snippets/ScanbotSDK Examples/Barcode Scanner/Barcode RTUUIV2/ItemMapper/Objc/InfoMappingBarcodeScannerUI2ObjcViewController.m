//
//  InfoMappingBarcodeScannerUI2ObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 20.12.23.
//

#import "InfoMappingBarcodeScannerUI2ObjcViewController.h"
@import ScanbotSDK;

@interface InfoMappingBarcodeScannerUI2ObjcViewController () <SBSDKUI2BarcodeItemMapper>

@end

@implementation InfoMappingBarcodeScannerUI2ObjcViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Start scanning here. Usually this is an action triggered by some button or menu.
    [self startScanning];
}

- (void)startScanning {
    
    // Create the default configuration object.
    SBSDKUI2BarcodeScannerConfiguration *configuration = [[SBSDKUI2BarcodeScannerConfiguration alloc] init];
    
    // Create the default single scan use case object.
    SBSDKUI2SingleScanningMode *usecase = [[SBSDKUI2SingleScanningMode alloc] init];
    
    // Enable the confirmation sheet.
    usecase.confirmationSheetEnabled = YES;
    
    // Set the item mapper.
    usecase.barcodeInfoMapping.barcodeItemMapper = self;
    
    // Retrieve the instance of the error state from the use case object.
    SBSDKUI2BarcodeItemErrorState *errorState = usecase.barcodeInfoMapping.errorState;
    
    // Configure the title.
    errorState.title.text = @"Error_Title";
    errorState.title.color = [[SBSDKUI2Color alloc] initWithColorString:@"#000000"];
    
    // Configure the subtitle.
    errorState.subtitle.text = @"Error_Subtitle";
    errorState.subtitle.color = [[SBSDKUI2Color alloc] initWithColorString:@"#000000"];
    
    // Configure the cancel button.
    errorState.cancelButton.text = @"Cancel";
    errorState.cancelButton.foreground.color = [[SBSDKUI2Color alloc] initWithColorString:@"#C8193C"];
    
    // Configure the retry button.
    errorState.retryButton.text = @"Retry";
    errorState.retryButton.foreground.iconVisible = YES;
    errorState.retryButton.foreground.color = [[SBSDKUI2Color alloc] initWithColorString:@"#FFFFFF"];
    errorState.retryButton.background.fillColor = [[SBSDKUI2Color alloc] initWithColorString:@"#C8193C"];
    
    // Set the configured error state.
    usecase.barcodeInfoMapping.errorState = errorState;
    
    // Set the configured use case.
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

- (void)mapBarcodeItemWithItem:(SBSDKUI2BarcodeItem * _Nonnull)item
                      onResult:(void (^ _Nonnull)(SBSDKUI2BarcodeMappedData * _Nonnull))onResult
                       onError:(void (^)(void))onError {
    
    // Handle the item.
    // e.g fetching the product info.
    
    BOOL fetchedSuccessfully = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (fetchedSuccessfully) {
            
            // Show Mapped data.
            
            NSString *fetchedTitle = @"Title";
            NSString *fetchedSubtitle = @"Subtitle";
            NSString *fetchedImageUrl = @"Image_URL";
            
            // You can also pass the `SBSDKUI2BarcodeMappedData.barcodeImageKey` instead of the fetched image
            // to display the original barcode image.
            
            // Create an instance of a mapped data.
            SBSDKUI2BarcodeMappedData *mappedData = [[SBSDKUI2BarcodeMappedData alloc] initWithTitle:fetchedTitle
                                                                                            subtitle:fetchedSubtitle
                                                                                        barcodeImage:fetchedImageUrl];
            
            // Pass the mapped data object in an `onResult` completion handler.
            onResult(mappedData);
            
        } else {
            
            // Call the onError completion handler.
            onError();
        }
    });
}

@end

