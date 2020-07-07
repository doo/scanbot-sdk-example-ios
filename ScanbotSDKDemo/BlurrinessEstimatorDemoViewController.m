//
//  BlurrinessEstimatorDemoViewController.m
//  SBSDK Internal Demo
//
//  Created by Sebastian Husche on 07.07.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

#import "BlurrinessEstimatorDemoViewController.h"
@import ScanbotSDK;

@interface BlurrinessEstimatorDemoViewController() <SBSDKCameraSessionDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) SBSDKCameraSession *cameraSession;
@property (assign, nonatomic) BOOL liveEstimationEnabled;
@property (strong, nonatomic) SBSDKBlurrinessEstimator *estimator;
@property (strong, nonatomic) SBSDKFrameLimiter *limiter;
@end

@implementation BlurrinessEstimatorDemoViewController

- (SBSDKCameraSession *)cameraSession {
    if (!_cameraSession) {
        _cameraSession = [[SBSDKCameraSession alloc] initForFeature:FeatureImageProcessing];
        _cameraSession.videoDelegate = self;
    }
    return _cameraSession;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.estimator = [[SBSDKBlurrinessEstimator alloc] init];
    self.limiter = [[SBSDKFrameLimiter alloc] initWithFPSCount:10];
    self.resultLabel.text = nil;
    self.containerView.backgroundColor = [UIColor blackColor];
    [self.containerView.layer addSublayer:self.cameraSession.previewLayer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.cameraSession startSession];
    self.liveEstimationEnabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.liveEstimationEnabled = NO;
    [self.cameraSession stopSession];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.cameraSession.previewLayer.frame = self.view.bounds;
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    self.cameraSession.videoOrientation = [self videoOrientationFromInterfaceOrientation];
}

- (void)showResult:(double)result alert:(BOOL)asAlert {
    NSString *resultString = [NSString stringWithFormat:@"Blurriness = %0.0f%%", result * 100.0f];
    if (asAlert) {
        self.liveEstimationEnabled = NO;
        self.cameraSession.previewLayer.hidden = YES;
        [self.cameraSession stopSession];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Blurriness Estimation"
                                                                       message:resultString
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
            [self.cameraSession startSession];
            self.cameraSession.previewLayer.hidden = NO;
            self.liveEstimationEnabled = YES;
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        self.resultLabel.text = resultString;
    }
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {
    
    if (!self.liveEstimationEnabled || ![self.limiter isReadyForNextFrame]) {
        return;
    }
    
    UIImage *image = [UIImage sbsdk_imageFromSampleBuffer:sampleBuffer orientation:self.cameraSession.videoOrientation];
    
    double result = [self.estimator estimateImageBlurriness:image];

    __weak id weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself showResult:result alert:NO];
    });
}

- (IBAction)selectImageButtonTapped:(id)sender {
    self.liveEstimationEnabled = NO;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    self.liveEstimationEnabled = YES;
    if (!self.cameraSession.isSessionRunning) {
        [self.cameraSession startSession];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = (UIImage *)info[UIImagePickerControllerOriginalImage];
    double result = [self.estimator estimateImageBlurriness:image];
    __weak id weakself = self;
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:^{
        [weakself showResult:result alert:YES];
    }];
}

@end
