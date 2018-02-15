//
//  DisabilityCertificatesLiveDemoViewController.m
//  ScanbotSDKDemo
//
//  Created by Andrew Petrus on 30.11.17.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import "DisabilityCertificatesLiveDemoViewController.h"
#import "DisabilityCertificatesRecognizerResultViewController.h"
@import ScanbotSDK;

@interface DisabilityCertificatesLiveDemoViewController () <SBSDKCameraSessionDelegate>

@property (nonatomic, strong) SBSDKDisabilityCertificatesRecognizer *recognizer;
@property (nonatomic, strong) SBSDKCameraSession *cameraSession;

@property (nonatomic) BOOL recognitionEnabled;
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) SBSDKDisabilityCertificatesRecognizerResult *result;

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
    self.recognitionEnabled = YES;
    self.cameraSession.captureSession.sessionPreset = AVCaptureSessionPreset1920x1080;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.cameraSession.previewLayer.frame = self.view.bounds;
}

- (void)recognizeInformationFromSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    self.result = [self.recognizer recognizeFromSampleBuffer:sampleBuffer
                                                 orientation:self.cameraSession.videoOrientation];
    if (self.result != nil && self.result.recognitionSuccessful) {
        self.originalImage = [self imageFromCMSampleBufferRef:sampleBuffer];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showResult];
        });
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDCResultsLive"]) {
        DisabilityCertificatesRecognizerResultViewController *resultController = (DisabilityCertificatesRecognizerResultViewController *)segue.destinationViewController;
        resultController.originalImage = self.originalImage;
        resultController.selectedImage = self.originalImage;
        resultController.initialResult = self.result;
    }
}

- (UIImage *)imageFromCMSampleBufferRef:(CMSampleBufferRef)ref {
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(ref);
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imageRef = [context createCGImage:ciImage
                                        fromRect:CGRectMake(0, 0, CVPixelBufferGetWidth(pixelBuffer), CVPixelBufferGetHeight(pixelBuffer))];
    return [UIImage imageWithCGImage:imageRef];
}

- (void)showResult {
    self.recognitionEnabled = NO;
    [self performSegueWithIdentifier:@"showDCResultsLive" sender:nil];
}

#pragma mark - SBSDKCameraSessionDelegate methods

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {
    if (self.recognitionEnabled) {
        [self recognizeInformationFromSampleBuffer:sampleBuffer];
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
