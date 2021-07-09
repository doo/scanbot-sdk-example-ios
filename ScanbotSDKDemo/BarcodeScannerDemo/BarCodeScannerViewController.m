//
//  BarCodeScannerViewController.m
//  SBSDK Internal Demo
//
//  Created by Andrew Petrus on 17.01.19.
//  Copyright © 2019 doo GmbH. All rights reserved.
//

#import "BarCodeScannerViewController.h"
#import "BarCodeScannerResultsTableViewController.h"
#import "BarCodeTypesListViewController.h"
@import ScanbotSDK;

@interface BarCodeScannerViewController () <SBSDKCameraSessionDelegate, UINavigationControllerDelegate,
UIImagePickerControllerDelegate, BarCodeTypesListViewControllerDelegate>

@property (nonatomic, strong) SBSDKCameraSession *cameraSession;
@property (nonatomic, strong) SBSDKBarcodeScanner *scanner;
@property (nonatomic, strong) SBSDKPolygonLayer *polygonLayer;
@property (nonatomic, strong) NSArray<SBSDKBarcodeType *> *selectedBarCodeTypes;
@property (nonatomic, strong) NSArray<SBSDKBarcodeScannerResult *> *currentResults;
@property (nonatomic) BOOL liveDetectionEnabled;
@property (nonatomic, strong) SBSDKFrameLimiter *frameLimiter;
@property (nonatomic, strong) UISwitch *polygonsSwitch;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (nonatomic) BOOL showDebugLayer;
@end

@implementation BarCodeScannerViewController

@synthesize polygonsSwitch;

- (SBSDKCameraSession *)cameraSession {
    if (!_cameraSession) {
        _cameraSession = [[SBSDKCameraSession alloc] initForFeature:FeatureQRCode];
        _cameraSession.videoDelegate = self;
    }
    return _cameraSession;
}

- (SBSDKPolygonLayer *)polygonLayer {
    if (!_polygonLayer) {
        UIColor *color = [UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f];
        _polygonLayer = [[SBSDKPolygonLayer alloc] initWithLineColor:color];
    }
    return _polygonLayer;
}

- (SBSDKFrameLimiter *)frameLimiter {
    if (!_frameLimiter) {
        _frameLimiter = [[SBSDKFrameLimiter alloc] initWithFPSCount:25];
    }
    return _frameLimiter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.cameraSession.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
    [self.view.layer addSublayer:self.cameraSession.previewLayer];
    [self.view.layer addSublayer:self.polygonLayer];
    
    [self configureBarCodeTypes:[SBSDKBarcodeType commonTypes]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.cameraSession startSession];
    self.liveDetectionEnabled = YES;
    self.showDebugLayer = NO;
    
    [self.view bringSubviewToFront:self.toolbar];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.liveDetectionEnabled = NO;
    [super viewWillDisappear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.cameraSession.previewLayer.frame = self.view.bounds;
    self.polygonLayer.frame = self.view.bounds;
    [self addPolygonsSwitch];
}

- (void)addPolygonsSwitch {
    self.polygonsSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(20, 100, 250, 50)];
    //[self.polygonsSwitch setOn:NO];
    [self.polygonsSwitch addTarget:self
                            action:@selector(polygonsSwitchIsChanged:)
                  forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.polygonsSwitch];
    [self.view bringSubviewToFront:self.polygonsSwitch];
}

- (IBAction)selectImageButtonTapped:(id)sender {
    self.liveDetectionEnabled = NO;
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker
                       animated:YES
                     completion:nil];
}

- (IBAction)selectTypesButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"showBarCodeTypesSelectionVCFromBasicDemo" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showBarCodeScannerResults"]) {
        if (segue.destinationViewController) {
            BarCodeScannerResultsTableViewController *vc =
            (BarCodeScannerResultsTableViewController *)segue.destinationViewController;
            vc.results = self.currentResults;
        }
    } else if ([segue.identifier isEqualToString:@"showBarCodeTypesSelectionVCFromBasicDemo"]) {
        if (segue.destinationViewController) {
            BarCodeTypesListViewController *vc = (BarCodeTypesListViewController *)segue.destinationViewController;
            vc.delegate = self;
            vc.selectedBarCodeTypes = self.selectedBarCodeTypes;
        }
    }
}

- (void)configureBarCodeTypes:(NSArray<SBSDKBarcodeType *> *)newTypes {
    self.selectedBarCodeTypes = newTypes;
    self.scanner = [[SBSDKBarcodeScanner alloc] initWithFrameAccumulator:1
                                                                   types:self.selectedBarCodeTypes
                                                                liveMode:YES];
    
    SBSDKBarcodeAdditionalParameters *parameters = [[SBSDKBarcodeAdditionalParameters alloc] init];
    self.scanner.additionalParameters = parameters;
}

#pragma mark - BarCode types selection delegate

- (void)barCodeTypesSelectionChanged:(NSArray<SBSDKBarcodeType *> *)newTypes {
    [self configureBarCodeTypes:newTypes];
}

- (void) polygonsSwitchIsChanged:(UISwitch *)paramSender {
    if (![paramSender isOn]) {
        self.polygonLayer.path = nil;
    }
    self.showDebugLayer = paramSender.isOn;
}

#pragma mark - UIImagePickerControllerDelegate


- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = (UIImage *)info[UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:^{
        self.scanner.useLiveMode = NO;
        self.currentResults = [self.scanner detectBarCodesOnImage:image];
        [self performSegueWithIdentifier:@"showBarCodeScannerResults" sender:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    self.liveDetectionEnabled = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    self.scanner.useLiveMode = YES;
    
    NSArray<SBSDKBarcodeScannerResult *> *results =
    [self.scanner detectBarCodesOnSampleBuffer:sampleBuffer
                                   orientation:self.cameraSession.videoOrientation];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.liveDetectionEnabled) {
            if (self.polygonsSwitch.isOn) {
                // show live results as polygons
                [self showLiveResults:results];
                return;
            }

            if (results.count > 0) {
                // beep tone & vibrate
                AudioServicesPlaySystemSound(1052);
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                // stop detection and show results in detail
                self.liveDetectionEnabled = NO;
                self.currentResults = results;
                [self performSegueWithIdentifier:@"showBarCodeScannerResults" sender:nil];
            }
        }
    });
}

- (void)showLiveResults:(NSArray<SBSDKBarcodeScannerResult *> *)results {
    [CATransaction begin];
    [CATransaction setValue: (id) kCFBooleanTrue forKey: kCATransactionDisableActions];
    self.polygonLayer.path = nil;
    if (results.count != 0) {
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        for (SBSDKBarcodeScannerResult *result in results) {
            NSLog(@"Found bar code: %@", result.rawTextString);
            [bezierPath appendPath:[result.polygon bezierPathForPreviewLayer:self.cameraSession.previewLayer]];
        }
        self.polygonLayer.path = bezierPath.CGPath;
    }
    [CATransaction commit];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    self.cameraSession.videoOrientation = [self videoOrientationFromInterfaceOrientation];
}

@end
