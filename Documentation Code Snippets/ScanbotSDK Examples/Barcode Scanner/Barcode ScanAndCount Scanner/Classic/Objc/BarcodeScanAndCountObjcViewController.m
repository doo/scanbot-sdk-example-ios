//
//  BarcodeScanAndCountObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 06.06.23.
//

#import "BarcodeScanAndCountObjcViewController.h"
@import ScanbotSDK;

// This is a simple, empty view controller which acts as a container and delegate for the SBSDKBarcodeScanAndCountViewController.
@interface BarcodeScanAndCountObjcViewController () <SBSDKBarcodeScanAndCountViewControllerDelegate>

// The instance of the scanner view controller.
@property (strong, nonatomic) SBSDKBarcodeScanAndCountViewController *scannerViewController;

@end

@implementation BarcodeScanAndCountObjcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create the SBSDKBarcodeScanAndCountViewController instance.
    self.scannerViewController = [[SBSDKBarcodeScanAndCountViewController alloc] initWithParentViewController:self
                                                                                                   parentView:self.view];
    
    // Create new instance of the polygon style.
    SBSDKScanAndCountPolygonStyle *polygonStyle = [[SBSDKScanAndCountPolygonStyle alloc] init];
    
    // Enable the barcode polygon overlay.
    polygonStyle.polygonDrawingEnabled = YES;
    
    // Set the color for the results overlays polygons.
    polygonStyle.polygonColor = [[UIColor alloc] initWithRed:0 green:0.81 blue:0.65 alpha:0.8];
    
    // Set the color for the polygon's fill color.
    polygonStyle.polygonFillColor = [[UIColor alloc] initWithRed:0 green:0.81 blue:0.65 alpha:0.2];
    
    // Set the line width for the polygon.
    polygonStyle.lineWidth = 2;
    
    // Set the corner radius for the polygon.
    polygonStyle.cornerRadius = 8;
    
    // Set the capture mode of the scanner.
    self.scannerViewController.captureMode = SBSDKBarcodeScanAndCountCaptureModeCapturedImage;
}

// The implementation of the SBSDKBarcodeScanAndCountViewControllerDelegate.

// Implement this method to process detected barcodes.
- (void)barcodeScanAndCountController:(SBSDKBarcodeScanAndCountViewController *)controller
                    didDetectBarcodes:(NSArray<SBSDKBarcodeScannerResult *> *)codes {
    // Process the detected barcodes.
}

// Implement this optional function when you need a custom overlay to be displayed for the detected barcode.
- (UIView *)barcodeScanAndCountController:(SBSDKBarcodeScanAndCountViewController *)controller
                        overlayForBarcode:(SBSDKBarcodeScannerResult *)code {
    // provide a custom overlay view for the barcode
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"<image_name>"]];
}

@end
