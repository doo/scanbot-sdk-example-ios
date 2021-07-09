//
//  BarCodeScannerWithFinderViewController.m
//  ScanbotSDK Demo
//
//  Created by Andrew Petrus on 30.04.19.
//  Copyright © 2019 doo GmbH. All rights reserved.
//

#import "BarCodeScannerWithFinderViewController.h"
#import "BarCodeScannerResultsTableViewController.h"
#import "BarCodeTypesListViewController.h"
#import <QuartzCore/QuartzCore.h>

@import ScanbotSDK;

@interface BarCodeScannerWithFinderViewController () <SBSDKBarcodeScannerViewControllerDelegate, UINavigationControllerDelegate,
BarCodeTypesListViewControllerDelegate>

@property (nonatomic, strong) SBSDKBarcodeScannerViewController *scannerViewController;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (nonatomic, strong) NSArray<SBSDKBarcodeScannerResult *> *currentResults;
@property (nonatomic, assign) BOOL shouldDetectBarcodes;

@end

@implementation BarCodeScannerWithFinderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scannerViewController = [[SBSDKBarcodeScannerViewController alloc] initWithParentViewController:self parentView:nil];
    
    self.scannerViewController.viewFinderLineColor = [UIColor greenColor];
    self.scannerViewController.viewFinderLineWidth = 5;
    self.scannerViewController.finderAspectRatio = [[SBSDKAspectRatio alloc] initWithWidth:2 andHeight:1];
    self.scannerViewController.shouldUseFinderFrame = YES;
    self.scannerViewController.finderMinimumInset = UIEdgeInsetsMake(100, 50, 100, 50);
    [self configureBarCodeTypes:[SBSDKBarcodeType commonTypes]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.shouldDetectBarcodes = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.shouldDetectBarcodes = NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showBarCodeScannerResultsFromFinderView"]) {
        if (segue.destinationViewController) {
            BarCodeScannerResultsTableViewController *vc =
            (BarCodeScannerResultsTableViewController *)segue.destinationViewController;
            vc.results = self.currentResults;
        }
    } else if ([segue.identifier isEqualToString:@"showBarCodeTypesSelectionVCFromFinderDemo"]) {
        if (segue.destinationViewController) {
            BarCodeTypesListViewController *vc = (BarCodeTypesListViewController *)segue.destinationViewController;
            vc.delegate = self;
            vc.selectedBarCodeTypes = self.scannerViewController.acceptedBarcodeTypes;
        }
    }
}

- (IBAction)selectTypesButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"showBarCodeTypesSelectionVCFromFinderDemo" sender:nil];
}

- (void)configureBarCodeTypes:(NSArray<SBSDKBarcodeType *> *)newTypes {
    self.scannerViewController.acceptedBarcodeTypes = newTypes;
}

#pragma mark - BarCode types selection delegate

- (void)barCodeTypesSelectionChanged:(NSArray<SBSDKBarcodeType *> *)newTypes {
    [self configureBarCodeTypes:newTypes];
}

#pragma mark - SBSDKBarcodeScannerViewControllerDelegate methods

- (void)barcodeScannerController:(SBSDKBarcodeScannerViewController *)controller
                didDetectBarcodes:(NSArray<SBSDKBarcodeScannerResult *> *)codes {
    self.currentResults = codes;
    [self performSegueWithIdentifier:@"showBarCodeScannerResultsFromFinderView" sender:nil];
}

- (BOOL)barcodeScannerControllerShouldDetectBarcodes:(SBSDKBarcodeScannerViewController *)controller {
    return self.shouldDetectBarcodes;
}

@end
