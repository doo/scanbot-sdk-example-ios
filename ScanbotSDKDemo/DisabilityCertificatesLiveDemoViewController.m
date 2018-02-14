//
//  DisabilityCertificatesLiveDemoViewController.m
//  ScanbotSDKDemo
//
//  Created by Andrew Petrus on 30.11.17.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import "DisabilityCertificatesLiveDemoViewController.h"
@import ScanbotSDK;

@interface DisabilityCertificatesLiveDemoViewController () <SBSDKCameraSessionDelegate>

@property (nonatomic, strong) SBSDKDisabilityCertificatesRecognizer *recognizer;
@property (nonatomic) BOOL recognitionEnabled;

@property (nonatomic, strong) SBSDKCameraSession *cameraSession;

@end

@implementation DisabilityCertificatesLiveDemoViewController

- (SBSDKCameraSession *)cameraSession {
    if (!_cameraSession) {
        _cameraSession = [[SBSDKCameraSession alloc] initForFeature:FeatureDisabilityCertRecognition];
        _cameraSession.videoDelegate = self;
    }
    return _cameraSession;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view.layer addSublayer:self.cameraSession.previewLayer];
    self.view.backgroundColor = [UIColor blackColor];
    self.recognizer = [SBSDKDisabilityCertificatesRecognizer new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.cameraSession startSession];
    self.cameraSession.captureSession.sessionPreset = AVCaptureSessionPreset1920x1080;
    
    self.recognitionEnabled = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.cameraSession.previewLayer.frame = self.view.bounds;
}

- (void)recognizeInformationFromSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    SBSDKDisabilityCertificatesRecognizerResult *result = [self.recognizer recognizeFromSampleBuffer:sampleBuffer
                                                                                         orientation:self.cameraSession.videoOrientation];
    if (result != nil && result.recognitionSuccessful) {
        self.recognitionEnabled = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showResult:result];
        });
    }
}

- (void)showResult:(SBSDKDisabilityCertificatesRecognizerResult *)result {
    NSString *message = [result stringRepresentation];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Result"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         self.recognitionEnabled = YES;
                                                     }];
    [alert addAction:okAction];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

#pragma mark - SBSDKCameraSessionDelegate methods

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {
    if (self.recognitionEnabled) {
        SBSDKDisabilityCertificatesRecognizerResult *result = [self.recognizer recognizeFromSampleBuffer:sampleBuffer
                                                                                             orientation:self.cameraSession.videoOrientation];
        if (result != nil && result.recognitionSuccessful) {
            self.recognitionEnabled = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showResult:result];
            });
        }
    }
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
