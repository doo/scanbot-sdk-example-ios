//
//  EHICDemoViewController.m
//  ScanbotSDKDemo
//
//  Created by Yevgeniy Knizhnik on 12.08.19.
//  Copyright © 2019 doo GmbH. All rights reserved.
//

#import "EHICDemoViewController.h"
@import ScanbotSDK;

@interface EHICDemoViewController () <SBSDKCameraSessionDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *statusView;

@property (nonatomic, strong) SBSDKHealthInsuranceCardRecognizer *recognizer;
@property (nonatomic, strong) SBSDKCameraSession *cameraSession;

@property (nonatomic) BOOL recognitionEnabled;
@property (nonatomic) CGRect machineReadableZoneRect;

@end

@implementation EHICDemoViewController

- (SBSDKCameraSession *)cameraSession {
    if (!_cameraSession) {
        _cameraSession = [[SBSDKCameraSession alloc] initForFeature:FeatureEHICRecognition];
        _cameraSession.videoDelegate = self;
    }
    return _cameraSession;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recognizer = [SBSDKHealthInsuranceCardRecognizer new];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view.layer addSublayer:self.cameraSession.previewLayer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.cameraSession startSession];
    
    [self.view bringSubviewToFront:self.statusView];
    
    self.recognitionEnabled = YES;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.cameraSession.previewLayer.frame = self.view.bounds;
    [self updateVideoOrientation];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    self.recognitionEnabled = YES;
    if (!self.cameraSession.isSessionRunning) {
        [self.cameraSession startSession];
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {
    if (self.recognitionEnabled) {
        SBSDKHealthInsuranceCardRecognitionResult *result = [self.recognizer detectAndRecognizeFromSampleBuffer:sampleBuffer
                                                                                                    orientation:self.cameraSession.videoOrientation];
        if (result != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showResult:result];
            });
        }
    }
}

- (void)showResult:(SBSDKHealthInsuranceCardRecognitionResult *)result {
    switch (result.status) {
            case SBSDKHealthInsuranceCardDetectionStatusSuccess:
            self.statusView.text = @"Card recognized";
            break;
            case SBSDKHealthInsuranceCardDetectionStatusFailedDetection:
            self.statusView.text = @"Please align the back side of the card in the frame above to scan it";
            return;
            case SBSDKHealthInsuranceCardDetectionStatusFailedValidation:
            self.statusView.text = @"Card found, please wait...";
            return;
    }
    
    self.recognitionEnabled = NO;
    NSString *resultMessage = [result stringRepresentation];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Result"
                                                                   message:resultMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         self.recognitionEnabled = YES;
                                                     }];
    [alert addAction:okAction];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange: previousTraitCollection];
    [self updateVideoOrientation];
}

- (void)updateVideoOrientation {
    self.cameraSession.videoOrientation = self.videoOrientationFromInterfaceOrientation;
}

@end
