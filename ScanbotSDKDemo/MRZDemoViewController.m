//
//  MRZDemoViewController.m
//  ScanbotSDKDemo
//
//  Created by Andrew Petrus on 28.09.16.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import "MRZDemoViewController.h"
@import ScanbotSDK;

@interface MRZDemoViewController () <SBSDKCameraSessionDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *blackView;
@property (weak, nonatomic) IBOutlet UIImageView *templateView;

@property (nonatomic, strong) SBSDKMachineReadableZoneRecognizer *recognizer;
@property (nonatomic, strong) SBSDKCameraSession *cameraSession;

@property (nonatomic) BOOL recognitionEnabled;
@property (nonatomic) CGRect machineReadableZoneRect;

@end

@implementation MRZDemoViewController

- (SBSDKCameraSession *)cameraSession {
    if (!_cameraSession) {
        _cameraSession = [[SBSDKCameraSession alloc] initForFeature:FeatureMRZRecognition];
        _cameraSession.videoDelegate = self;
    }
    return _cameraSession;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recognizer = [SBSDKMachineReadableZoneRecognizer new];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view.layer addSublayer:self.cameraSession.previewLayer];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.cameraSession.captureSession.sessionPreset = AVCaptureSessionPreset1920x1080;
    [self.cameraSession startSession];
    
    [self.view bringSubviewToFront:self.blackView];
    [self.view bringSubviewToFront:self.imageView];
    [self.view bringSubviewToFront:self.templateView];
    
    self.recognitionEnabled = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.cameraSession.previewLayer.frame = self.view.bounds;
    [self recalculateMRZRect];
}

#pragma mark - Custom helpers

- (CGSize)previewSizeFromCameraSessionPreset {
    // in this demo we use 1920x1080 capture preset
    if (self.view.frame.size.height > self.view.frame.size.width) {
        return CGSizeMake(1080, 1920);
    }
    return CGSizeMake(1920, 1080);
}

- (void)recalculateMRZRect {
    const CGFloat documentRelativeWidth = 1.47f;
    const CGFloat documentRelativeHeight = 0.68f;
    const CGFloat edgeMargin = 15.0f;
    
    CGFloat documentWidth = self.view.frame.size.width;
    CGFloat documentHeight = documentWidth * documentRelativeHeight;
    CGFloat documentOriginX = 0.0f;
    CGFloat documentOriginY = self.view.frame.size.height / 2 - documentHeight / 2;
    
    if (self.view.frame.size.height < self.view.frame.size.width) { // Landscape mode
        documentHeight = self.view.frame.size.height;
        documentWidth = documentHeight * documentRelativeWidth;
        documentOriginX = self.view.frame.size.width / 2 - documentWidth / 2;
        documentOriginY = 0.0f;
    }
    
    const CGFloat xScale = [self previewSizeFromCameraSessionPreset].width / self.view.frame.size.width;
    const CGFloat yScale = [self previewSizeFromCameraSessionPreset].height / self.view.frame.size.height;
    self.machineReadableZoneRect = CGRectMake((documentOriginX + edgeMargin) * xScale,
                              (documentOriginY + documentHeight / 3 * 2 - edgeMargin) * yScale,
                              (documentWidth - edgeMargin) * xScale,
                              (documentHeight / 3) * yScale);
}

#pragma mark - Custom actions

- (IBAction)selectImageButtoTapped:(id)sender {
    [self.cameraSession stopSession];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    self.recognitionEnabled = NO;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerController delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    self.recognitionEnabled = YES;
    if (!self.cameraSession.isSessionRunning) {
        [self.cameraSession startSession];
        self.blackView.hidden = YES;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary<NSString *,id> *)editingInfo {
    self.imageView.image = image;
    self.blackView.hidden = NO;
    
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 SBSDKMachineReadableZoneRecognizerResult *result = [self.recognizer recognizePersonalIdentityFromImage:image];
                                 [self showResult:result];
                             }];
}

#pragma mark - SBSDKCameraSessionDelegate methods

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {
    if (self.recognitionEnabled) {
        SBSDKMachineReadableZoneRecognizerResult *result = [self.recognizer recognizePersonalIdentityFromSampleBuffer:sampleBuffer
                                                                                                          orientation:self.cameraSession.videoOrientation searchMachineReadableZone:NO
                                                                                              machineReadableZoneRect:self.machineReadableZoneRect];
        if (result != nil && result.recognitionSuccessfull) {
            self.recognitionEnabled = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showResult:result];
            });
        }
    }
}

- (void)showResult:(SBSDKMachineReadableZoneRecognizerResult *)result {
    NSString *resultMessage = result ? [result stringRepresentation] : @"Nothing detected";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Result"
                                                                   message:resultMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         self.recognitionEnabled = YES;
                                                         if (self.imageView.image) {
                                                             self.imageView.image = nil;
                                                             self.blackView.hidden = YES;
                                                             if (!self.cameraSession.isSessionRunning) {
                                                                 [self.cameraSession startSession];
                                                             }
                                                         }
                                                     }];
    [alert addAction:okAction];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    AVCaptureVideoOrientation videoOrientation = AVCaptureVideoOrientationPortrait;
    switch (orientation) {
            
        case UIInterfaceOrientationPortrait:
            videoOrientation = AVCaptureVideoOrientationPortrait;
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
            
        case UIInterfaceOrientationLandscapeLeft:
            videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            videoOrientation = AVCaptureVideoOrientationLandscapeRight;
            
        default:
            break;
    }
    self.cameraSession.videoOrientation = videoOrientation;
}

@end
