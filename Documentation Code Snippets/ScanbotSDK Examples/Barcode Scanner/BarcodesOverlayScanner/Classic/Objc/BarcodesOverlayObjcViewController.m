//
//  BarcodesOverlayObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 29.11.22.
//

#import "BarcodesOverlayObjcViewController.h"
@import ScanbotSDK;

// This is a simple, empty view controller which acts as a container and delegate for the SBSDKBarcodeScannerViewController conforming SBSDKBarcodeTrackingOverlayControllerDelegate.
@interface BarcodesOverlayObjcViewController () <SBSDKBarcodeTrackingOverlayControllerDelegate>

// The instance of the scanner view controller.
@property (strong, nonatomic) SBSDKBarcodeScannerViewController *scannerViewController;

@end

@implementation BarcodesOverlayObjcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create the SBSDKBarcodeScannerViewController instance.
    self.scannerViewController = [[SBSDKBarcodeScannerViewController alloc] initWithParentViewController:self
                                                                                              parentView:self.view];
    
    // Set self as a trackingViewController's delegate.
    self.scannerViewController.trackingOverlayController.delegate = self;
    
    // Enable the barcodes tracking overlay.
    self.scannerViewController.isTrackingOverlayEnabled = YES;
    
    // Get current tracking configuration object.
    SBSDKBarcodeTrackingOverlayConfiguration *configuration =
    self.scannerViewController.trackingOverlayController.configuration;
    
    // Set the color for the polygons of the tracked barcodes.
    configuration.polygonStyle.polygonColor = [UIColor colorWithRed:0 green:0.81 blue:0.65 alpha:0.8];
    
    // Set the color for the polygons of the selected tracked barcodes.
    configuration.polygonStyle.polygonSelectedColor = [UIColor colorWithRed:0.784 green:0.1 blue:0.235 alpha:0.8];
    
    // Set the text color of the tracked barcodes.
    configuration.textStyle.textColor = [UIColor blackColor];
    
    // Set the text background color of the tracked barcodes.
    configuration.textStyle.textBackgroundColor = [UIColor colorWithRed:0 green:0.81 blue:0.65 alpha:0.8];
    
    // Set the text color of the selected tracked barcodes.
    configuration.textStyle.selectedTextColor = [UIColor whiteColor];
    
    // Set the text background color of the selected tracked barcodes.
    configuration.textStyle.textBackgroundSelectedColor = [UIColor colorWithRed:0.784 green:0.1 blue:0.235 alpha:0.8];
    
    // Set the text format of the tracked barcodes.
    configuration.textStyle.trackingOverlayTextFormat = SBSDKBarcodeOverlayFormatCodeAndType;
    
    // Set the tracking configuration to apply it.
    self.scannerViewController.trackingOverlayController.configuration = configuration;
}

// The implementation of the SBSDKBarcodeTrackingOverlayControllerDelegate.

// Implement this method to handle user's selection of a tracked barcode.
- (void)barcodeTrackingOverlay:(SBSDKBarcodeTrackingOverlayController *)controller
               didTapOnBarcode:(SBSDKBarcodeScannerResult *)barcode {
    // Process the barcode selected by the user.
}

// Implement this method when you need to customize the polygon style individually for every barcode detected.
- (SBSDKBarcodeTrackedViewPolygonStyle *)barcodeTrackingOverlay:(SBSDKBarcodeTrackingOverlayController *)controller
                                                polygonStyleFor:(SBSDKBarcodeScannerResult *)barcode {
    
    SBSDKBarcodeTrackedViewPolygonStyle *style = [[SBSDKBarcodeTrackedViewPolygonStyle alloc] init];
    if (barcode.type == [SBSDKBarcodeType qrCode]) {
        style.polygonColor = [UIColor redColor];
        style.polygonBackgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.2];
    }
    
    return style;
}

// Implement this method when you need to customize the text style individually for every barcode detected.
- (SBSDKBarcodeTrackedViewTextStyle *)barcodeTrackingOverlay:(SBSDKBarcodeTrackingOverlayController *)controller
                                                textStyleFor:(SBSDKBarcodeScannerResult *)barcode {
    
    SBSDKBarcodeTrackedViewTextStyle *style = [[SBSDKBarcodeTrackedViewTextStyle alloc] init];
    if (barcode.type == [SBSDKBarcodeType qrCode]) {
        style.textBackgroundColor  = [[UIColor purpleColor] colorWithAlphaComponent:0.2];
    }
    
    return style;
}

@end
