//
//  BarcodesBatchObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 20.05.21.
//

#import "BarcodesBatchObjcViewController.h"
@import ScanbotSDK;

// This is a simple, empty view controller which acts as a container and delegate for the SBSDKBarcodeScannerViewController.
@interface BarcodesBatchObjcViewController () <SBSDKBarcodeScannerViewControllerDelegate>

// The instance of the scanner view controller.
@property (strong, nonatomic) SBSDKBarcodeScannerViewController *scannerViewController;

// Property to indicate whether you want the scanner to detect barcodes or not.
@property (nonatomic, assign) BOOL shouldDetectBarcodes;

@end

@implementation BarcodesBatchObjcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create the SBSDKBarcodeScannerViewController instance.
    self.scannerViewController = [[SBSDKBarcodeScannerViewController alloc] initWithParentViewController:self
                                                                                              parentView:self.view];
    
    // Get current view finder configuration object
    SBSDKBaseScannerViewFinderConfiguration *config = self.scannerViewController.viewFinderConfiguration;
    
    // Enable the view finder.
    config.isViewFinderEnabled = YES;
    
    // Set the finder's aspect ratio.
    config.aspectRatio = [[SBSDKAspectRatio alloc] initWithWidth:2 andHeight:1];
    
    // Set the finder's minimum insets.
    config.minimumInset = UIEdgeInsetsMake(100, 50, 100, 50);
        
    // Configure the view finder colors and line properties.
    config.lineColor = [UIColor redColor];
    config.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
    config.lineWidth = 2;
    config.lineCornerRadius = 8;
    
    // Set the view finder configuration to apply it.
    self.scannerViewController.viewFinderConfiguration = config;

    // Get current energy configuration.
    SBSDKBaseScannerEnergyConfiguration *energyConfig = self.scannerViewController.energyConfiguration;

    // Set detection rate.
    energyConfig.detectionRate = 5;
    
    // Set the energy configuration to apply it.
    self.scannerViewController.energyConfiguration = energyConfig;

    // Define and set barcode types that should be accepted by the scanner.
    NSArray <SBSDKBarcodeType *> *commonTypes = [SBSDKBarcodeType commonTypes];
    self.scannerViewController.acceptedBarcodeTypes = commonTypes;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Start detecting barcodes when the screen is visible.
    self.shouldDetectBarcodes = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // Stop detecting barcodes when the screen is not visible.
    self.shouldDetectBarcodes = NO;
}

// The implementation of the SBSDKBarcodeScannerViewControllerDelegate.

// Implement this method to process detected barcodes.
- (void)barcodeScannerController:(SBSDKBarcodeScannerViewController *)controller
               didDetectBarcodes:(NSArray<SBSDKBarcodeScannerResult *> *)codes {
    // Process the detected barcodes.
}

// Implement this method when you need to pause the detection (e.g. when showing the results).
- (BOOL)barcodeScannerControllerShouldDetectBarcodes:(SBSDKBarcodeScannerViewController *)controller {
    return self.shouldDetectBarcodes;
}

@end
