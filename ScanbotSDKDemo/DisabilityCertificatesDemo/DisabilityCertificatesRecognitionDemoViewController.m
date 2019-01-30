//
//  DisabilityCertificatesRecognitionDemoViewController.m
//  ScanbotSDKDemo
//
//  Created by Andrew Petrus on 14.11.17.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import "DisabilityCertificatesRecognitionDemoViewController.h"
#import "DisabilityCertificatesRecognizerResultViewController.h"
@import ScanbotSDK;

@interface DisabilityCertificatesRecognitionDemoViewController () <SBSDKScannerViewControllerDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) SBSDKScannerViewController *scannerViewController;

@property (nonatomic, strong) UIImage *capturedImage;
@property (nonatomic, strong) UIImage *originalImage;

@end

@implementation DisabilityCertificatesRecognitionDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.scannerViewController = [[SBSDKScannerViewController alloc] initWithParentViewController:self
                                                                                     imageStorage:nil];
    // define aspect ratios for german DC forms
    NSArray *aspectRatios = @[
                              [[SBSDKPageAspectRatio alloc] initWithWidth:14.8 andHeight:21.0], // white variant
                              [[SBSDKPageAspectRatio alloc] initWithWidth:14.8 andHeight:10.5] // yellow variant
                              ];
    self.scannerViewController.requiredAspectRatios = aspectRatios;
    self.scannerViewController.finderMode = SBSDKFinderModeAlways;
    self.scannerViewController.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self cleanHUDBackground];
}

- (void)cleanHUDBackground {
    [UIView animateWithDuration:0.25 animations:^{
        self.scannerViewController.HUDView.backgroundColor = [UIColor clearColor];
    }];
}

- (IBAction)selectImageButtonTapped:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDCResultFromImage"]) {
        DisabilityCertificatesRecognizerResultViewController *resultController = (DisabilityCertificatesRecognizerResultViewController *)segue.destinationViewController;
        resultController.originalImage = self.originalImage;
        resultController.selectedImage = self.capturedImage;
    }
}

#pragma mark - UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.scannerViewController.HUDView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
    }];
    
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 self.originalImage = image;
                                 self.capturedImage = image;
                                 [self performSegueWithIdentifier:@"showDCResultFromImage" sender:nil];
                             }];
}

#pragma mark - SBSDKScannerViewControllerDelegate

- (BOOL)scannerControllerShouldAnalyseVideoFrame:(SBSDKScannerViewController *)controller {
    return self.presentedViewController == nil && self.scannerViewController.autoShutterEnabled == YES;
}

- (void)scannerControllerWillCaptureStillImage:(SBSDKScannerViewController *)controller {
    [UIView animateWithDuration:0.25 animations:^{
        controller.HUDView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
    }];
}

- (void)scannerController:(SBSDKScannerViewController *)controller didCaptureImage:(UIImage *)image {
    self.originalImage = image;
}

- (void)scannerController:(SBSDKScannerViewController *)controller
  didCaptureDocumentImage:(UIImage *)documentImage {
    self.capturedImage = documentImage;
    [self performSegueWithIdentifier:@"showDCResultFromImage" sender:nil];
}

- (void)scannerController:(SBSDKScannerViewController *)controller didFailCapturingImage:(NSError *)error {
    [self cleanHUDBackground];
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
