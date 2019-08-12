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
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UILabel *textHintLabel;

@property (nonatomic, strong) SBSDKMachineReadableZoneRecognizer *recognizer;
@property (nonatomic, strong) SBSDKCameraSession *cameraSession;

@property (nonatomic) BOOL isViewAppeared;
@property (nonatomic) CGRect machineReadableZoneRect;

@end

@implementation MRZDemoViewController

- (SBSDKCameraSession *)cameraSession {
    if (!_cameraSession) {
        _cameraSession = [[SBSDKCameraSession alloc] initForFeature:FeatureMRZRecognition];
        _cameraSession.videoDelegate = self;
        _cameraSession.captureSession.sessionPreset = AVCaptureSessionPreset1920x1080;
    }
    return _cameraSession;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.recognizer = [SBSDKMachineReadableZoneRecognizer new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.cameraSession startSession];
    [self.cameraView.layer insertSublayer:self.cameraSession.previewLayer atIndex:0];
    self.isViewAppeared = YES;
    self.blackView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.cameraSession stopSession];
    self.isViewAppeared = NO;
    self.blackView.hidden = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.cameraSession.previewLayer.frame = self.cameraView.bounds;
    [self recalculateMRZRect];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self recalculateMRZRect];
        [self updateVideoOrientation];
    } completion:nil];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange: previousTraitCollection];
    [self updateVideoOrientation];
}

- (BOOL)shouldRecognize {
    return self.isViewAppeared && self.imageView.image == nil && self.presentedViewController == nil;
}

#pragma mark - Custom helpers

- (void)recalculateMRZRect {
    CGFloat aspectRatio = 1.47f;
    CGFloat edgeMargin = 15.0f;
    
    CGSize size = self.cameraView.frame.size;
    CGFloat heightLimit = size.height - (edgeMargin * 2);
    CGFloat widthLimit = size.width - (edgeMargin * 2);
    
    CGFloat targetHeight = widthLimit/aspectRatio;
    CGFloat targetWidth = widthLimit;
    
    if (targetHeight > heightLimit) {
        targetHeight = heightLimit;
        targetWidth = heightLimit * aspectRatio;
    }
    
    CGSize targetSize = CGSizeMake(targetWidth, targetHeight);
    CGPoint targetPoint = CGPointMake((size.width/2) - targetSize.width/2,
                                      (size.height/2) - targetSize.height/2);
    CGRect targetRect = CGRectMake(targetPoint.x, targetPoint.y, targetSize.width, targetSize.height);
    
    BOOL isLandscape = self.cameraView.frame.size.height < self.cameraView.frame.size.width;
    CGSize screenSize = self.cameraView.frame.size;
    CGSize imageSize = isLandscape ? CGSizeMake(1920, 1080) : CGSizeMake(1080, 1920); // AVCaptureSessionPreset1920x1080
    
    CGFloat xMultiplier = imageSize.width / screenSize.width;
    CGFloat yMultiplier = imageSize.height / screenSize.height;
    
    CGRect convertedRect = CGRectMake(targetRect.origin.x * xMultiplier,
                                      (targetRect.origin.y + (targetRect.size.height / 3 * 2)) * yMultiplier,
                                      targetRect.size.width * xMultiplier,
                                      targetRect.size.height / 3 * yMultiplier);
    
    self.machineReadableZoneRect = convertedRect;
}

- (void)updateVideoOrientation {
    self.cameraSession.videoOrientation = self.videoOrientationFromInterfaceOrientation;
}

#pragma mark - Custom actions

- (IBAction)selectImageButtoTapped:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
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
    
    __block BOOL shouldRecognize;
    dispatch_sync(dispatch_get_main_queue(), ^{
        shouldRecognize = [self shouldRecognize];
    });
    
    if (shouldRecognize) {
        SBSDKMachineReadableZoneRecognizerResult *result
        = [self.recognizer recognizePersonalIdentityFromSampleBuffer:sampleBuffer
                                                         orientation:self.cameraSession.videoOrientation
                                           searchMachineReadableZone:NO
                                             machineReadableZoneRect:self.machineReadableZoneRect];
        
        if (result != nil && result.recognitionSuccessfull) {
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
                                                         if (self.imageView.image) {
                                                             self.imageView.image = nil;
                                                             self.blackView.hidden = YES;
                                                         }
                                                     }];
    [alert addAction:okAction];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

@end
