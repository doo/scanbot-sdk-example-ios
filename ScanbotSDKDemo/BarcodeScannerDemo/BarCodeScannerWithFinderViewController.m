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

@interface BarCodeScannerWithFinderViewController () <SBSDKCameraSessionDelegate, UINavigationControllerDelegate,
BarCodeTypesListViewControllerDelegate>

@property (nonatomic, strong) SBSDKCameraSession *cameraSession;
@property (nonatomic, strong) SBSDKBarcodeScanner *scanner;
@property (nonatomic, strong) NSArray<SBSDKBarcodeType *> *selectedBarCodeTypes;
@property (nonatomic, strong) NSArray<SBSDKBarcodeScannerResult *> *currentResults;
@property (nonatomic) BOOL liveDetectionEnabled;
@property (nonatomic, strong) SBSDKFrameLimiter *frameLimiter;
@property (weak, nonatomic) IBOutlet UIView *finderView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (nonatomic) CGRect viewFrame;
@property (nonatomic) CGRect finderViewFrame;
@property (nonatomic) CGSize sampleBufferImageSize;

@end

@implementation BarCodeScannerWithFinderViewController

- (SBSDKCameraSession *)cameraSession {
    if (!_cameraSession) {
        _cameraSession = [[SBSDKCameraSession alloc] initForFeature:FeatureQRCode];
        _cameraSession.videoDelegate = self;
    }
    return _cameraSession;
}

- (SBSDKFrameLimiter *)frameLimiter {
    if (!_frameLimiter) {
        _frameLimiter = [[SBSDKFrameLimiter alloc] initWithFPSCount:5];
    }
    return _frameLimiter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view.layer addSublayer:self.cameraSession.previewLayer];
    self.cameraSession.captureSession.sessionPreset = AVCaptureSessionPreset1920x1080;
    self.scanner = [[SBSDKBarcodeScanner alloc] init];
    self.selectedBarCodeTypes = [SBSDKBarcodeType allTypes];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.cameraSession startSession];
    self.liveDetectionEnabled = YES;
    
    [self.view bringSubviewToFront:self.finderView];
    self.finderView.layer.borderColor = [UIColor greenColor].CGColor;
    self.finderView.layer.borderWidth = 5.0f;
    
    self.viewFrame = self.view.frame;
    self.finderViewFrame = self.finderView.frame;
    
    [self.view bringSubviewToFront:self.toolbar];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.liveDetectionEnabled = NO;
    [super viewWillDisappear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.cameraSession.previewLayer.frame = self.view.bounds;
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
            vc.selectedBarCodeTypes = self.selectedBarCodeTypes;
        }
    }
}

- (void)acquireInputImageSizeIfNeeded:(CMSampleBufferRef)sampleBuffer {
    if (self.sampleBufferImageSize.height != 0 || self.sampleBufferImageSize.width != 0) {
        return;
    }
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);

    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    if (self.viewFrame.size.width < self.viewFrame.size.height) {
        self.sampleBufferImageSize = CGSizeMake(MIN(width, height), MAX(width, height));
    } else {
        self.sampleBufferImageSize = CGSizeMake(MAX(width, height), MIN(width, height));
    }
}


- (IBAction)selectTypesButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"showBarCodeTypesSelectionVCFromFinderDemo" sender:nil];
}

#pragma mark - BarCode types selection delegate

- (void)barCodeTypesSelectionChanged:(NSArray<SBSDKBarcodeType *> *)newTypes {
    self.selectedBarCodeTypes = newTypes;
}

#pragma mark - SBSDKCameraSessionDelegate methods

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {
    
    if (!self.liveDetectionEnabled) {
        return;
    }
    
    if (![self.frameLimiter isReadyForNextFrame]) {
        return;
    }
    
    [self acquireInputImageSizeIfNeeded:sampleBuffer];
    const double inputWidth = self.sampleBufferImageSize.width;
    const double inputHeight = self.sampleBufferImageSize.height;
    const double finderHeight = inputHeight * self.finderViewFrame.size.height / self.viewFrame.size.height;
    const double finderWidth = inputWidth;
    const double finderY = self.finderViewFrame.size.height * (inputHeight / self.viewFrame.size.height) - 100.0;
    const double finderX = 0.0;
    CGRect searchRect = CGRectMake(finderX,
                                   finderY,
                                   finderWidth,
                                   finderHeight);
    
    NSArray<SBSDKBarcodeScannerResult *> *results =
    [self.scanner detectBarCodesOnSampleBuffer:sampleBuffer
                                       ofTypes:self.selectedBarCodeTypes
                                   orientation:self.cameraSession.videoOrientation
                                  searchInRect:searchRect];
    if (results.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.liveDetectionEnabled = NO;
            self.currentResults = results;
            [self performSegueWithIdentifier:@"showBarCodeScannerResultsFromFinderView" sender:nil];
        });
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    self.cameraSession.videoOrientation = [self videoOrientationFromInterfaceOrientation];
}

- (BOOL)shouldAutorotate {
    return false;
}

@end
