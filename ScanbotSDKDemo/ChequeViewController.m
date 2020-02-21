//
//  ChequeViewController.m
//  ScanbotSDKDemo
//
//  Created by Dmitry Zaytsev on 12/04/16.
//  Copyright (c) 2016 doo GmbH. All rights reserved.
//

#import "ChequeViewController.h"
#import "ScanbotSDKInclude.h"

@interface ChequeViewController () <SBSDKCameraSessionDelegate>

@property (nonatomic, strong) SBSDKCameraSession *cameraSession;
@property (nonatomic, strong) SBSDKChequeRecognizer *wrapper;
@property (nonatomic, strong) SBSDKPolygonLayer *polygonLayer;

@property (atomic, assign) BOOL recognitionEnabled;

@end



@implementation ChequeViewController

#pragma mark - Lazy instantiation

- (SBSDKChequeRecognizer *)wrapper {
    if (!_wrapper) {
        _wrapper =  [[SBSDKChequeRecognizer alloc] init];
    }
    return _wrapper;
}

- (SBSDKCameraSession *)cameraSession {
    if (!_cameraSession) {
        _cameraSession = [[SBSDKCameraSession alloc] initForFeature:FeatureCheque];
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

#pragma mark - Life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view.layer addSublayer:self.cameraSession.previewLayer];
    [self.view.layer addSublayer:self.polygonLayer];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.cameraSession.previewLayer.frame = self.view.bounds;
    self.polygonLayer.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.cameraSession startSession];
    self.recognitionEnabled = YES;
}

- (void)showResult:(SBSDKChequeRecognizerResult *)result {
    
    self.polygonLayer.path = [result.polygon bezierPathForPreviewLayer:self.cameraSession.previewLayer].CGPath;
    
    if (result == nil || result.routingNumberField.value.length == 0) {
        return;
    }
    
    self.polygonLayer.path = nil;
    
    self.recognitionEnabled = NO;
    
    NSMutableString *message = [[NSMutableString alloc] init];
    if (result.routingNumberField.value.length > 0) {
        [message appendString:[NSString stringWithFormat:@"Routing number: %@\n", result.routingNumberField.value]];
    }
    
    if (result.accountNumberField.value.length > 0) {
        [message appendString:[NSString stringWithFormat:@"Account number: %@\n", result.accountNumberField.value]];
    }

    if (result.chequeNumberField.value.length > 0) {
        [message appendString:[NSString stringWithFormat:@"Cheque number: %@\n", result.chequeNumberField.value]];
    }

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Recognized Cheque"
                                                                   message:[message copy]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                self.recognitionEnabled = YES;
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - SBSDKCameraSessionDelegate methods

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {
    
    if (!self.recognitionEnabled) {
        return;
    }
    
    AVCaptureVideoOrientation orientation = self.cameraSession.videoOrientation;
    SBSDKChequeRecognizerResult *result = [self.wrapper recognizeChequeOnBuffer:sampleBuffer orientation:orientation];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showResult:result];
    });
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
