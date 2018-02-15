//
//  DisabilityCertificatesRecognitionDemoViewController.m
//  ScanbotSDKDemo
//
//  Created by Andrew Petrus on 14.11.17.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import "DisabilityCertificatesRecognitionDemoViewController.h"
@import ScanbotSDK;

@interface DisabilityCertificatesRecognitionDemoViewController () <SBSDKScannerViewControllerDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *hudView;

@property (nonatomic, strong) SBSDKDisabilityCertificatesRecognizer *recognizer;
@property (strong, nonatomic) SBSDKScannerViewController *scannerViewController;
@property (nonatomic) BOOL recognitionEnabled;

@end

@implementation DisabilityCertificatesRecognitionDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.recognizer = [SBSDKDisabilityCertificatesRecognizer new];
    self.scannerViewController = [[SBSDKScannerViewController alloc] initWithParentViewController:self
                                                                                     imageStorage:nil];
    self.scannerViewController.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.recognitionEnabled = YES;
}

- (void)recognizeAUDataFromImage:(UIImage *)documentImage {
    SBSDKDisabilityCertificatesRecognizerResult *result = [self.recognizer recognizeFromImage:documentImage];
    [self showResult:result];
    [UIView animateWithDuration:0.25 animations:^{
        self.scannerViewController.HUDView.backgroundColor = [UIColor clearColor];
    }];
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

- (IBAction)selectImageButtonTapped:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    self.recognitionEnabled = NO;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerController delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    self.recognitionEnabled = YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary<NSString *,id> *)editingInfo {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.scannerViewController.HUDView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
    }];
    
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 [self recognizeAUDataFromImage:image];
                             }];
}

#pragma mark - SBSDKScannerViewControllerDelegate

- (BOOL)scannerControllerShouldAnalyseVideoFrame:(SBSDKScannerViewController *)controller {
    return (self.recognitionEnabled
            && self.presentedViewController == nil
            && self.scannerViewController.autoShutterEnabled == YES);
}

- (void)scannerControllerWillCaptureStillImage:(SBSDKScannerViewController *)controller {
    [UIView animateWithDuration:0.25 animations:^{
        controller.HUDView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
    }];
}

- (void)scannerController:(SBSDKScannerViewController *)controller
  didCaptureDocumentImage:(UIImage *)documentImage {
    [self recognizeAUDataFromImage:documentImage];
}

- (void)scannerController:(SBSDKScannerViewController *)controller didFailCapturingImage:(NSError *)error {
    [UIView animateWithDuration:0.25 animations:^{
        controller.HUDView.backgroundColor = [UIColor clearColor];
    }];
}

- (UIButton *)scannerControllerCustomShutterButton:(SBSDKScannerViewController *)controller {
    return nil;
}

- (UIView *)scannerController:(SBSDKScannerViewController *)controller
       viewForDetectionStatus:(SBSDKDocumentDetectionStatus)status {
    return nil;
}

- (void)scannerController:(SBSDKScannerViewController *)controller
        drawPolygonPoints:(NSArray *)pointValues
      withDetectionStatus:(SBSDKDocumentDetectionStatus)detectStatus
                  onLayer:(CAShapeLayer *)layer {
    UIColor *baseColor = [UIColor colorWithRed:0.173 green:0.612 blue:0.988 alpha:1];
    CGFloat lineWidth = 0.0f;
    CGFloat alpha = 0.3f;
    if (detectStatus == SBSDKDocumentDetectionStatusOK) {
        lineWidth = 2.0f;
        alpha = 0.5f;
    }
    layer.lineWidth = lineWidth;
    layer.strokeColor = baseColor.CGColor;
    layer.fillColor = [baseColor colorWithAlphaComponent:alpha].CGColor;
    UIBezierPath *path = nil;
    for (NSUInteger index = 0; index < pointValues.count; index ++) {
        if (index == 0) {
            path = [UIBezierPath bezierPath];
            [path moveToPoint:[pointValues[index] CGPointValue]];
        } else {
            [path addLineToPoint:[pointValues[index] CGPointValue]];
        }
    }
    [path closePath];
    layer.path = path.CGPath;
}

- (UIColor *)scannerController:(SBSDKScannerViewController *)controller
polygonColorForDetectionStatus:(SBSDKDocumentDetectionStatus)status {
    if (status == SBSDKDocumentDetectionStatusOK) {
        return [UIColor greenColor];
    }
    return [UIColor redColor];
}

- (BOOL)scannerController:(SBSDKScannerViewController *)controller
shouldRotateInterfaceForDeviceOrientation:(UIDeviceOrientation)orientation
                transform:(CGAffineTransform)transform {
    return !self.shouldAutorotate;
}


@end
