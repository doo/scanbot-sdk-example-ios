//
//  BlurrinessEstimatorDemoViewController.m
//  SBSDK Internal Demo
//
//  Created by Sebastian Husche on 07.07.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

#import "BlurrinessEstimatorDemoViewController.h"
@import ScanbotSDK;

@interface BlurrinessEstimatorDemoViewController() <SBSDKScannerViewControllerDelegate, UINavigationControllerDelegate,
UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) SBSDKScannerViewController *scannerViewController;
@property (strong, nonatomic) SBSDKBlurrinessEstimator *estimator;
@end

@implementation BlurrinessEstimatorDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scannerViewController = [[SBSDKScannerViewController alloc] initWithParentViewController:self
                                                                                       parentView:self.containerView
                                                                                     imageStorage:nil
                                                                            enableQRCodeDetection:NO];
    self.estimator = [[SBSDKBlurrinessEstimator alloc] init];
    self.scannerViewController.delegate = self;
    self.scannerViewController.detectionStatusHidden = YES;
}

- (IBAction)selectImageButtonTapped:(id)sender {
    [self darkenScreen];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)estimateAndShowResultsWithImage:(UIImage *)image {
    double result = [self.estimator estimateImageBlurriness:image];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf showResult:result];
    });
}

- (void)darkenScreen {
    [UIView animateWithDuration:0.2 animations:^{
        self.scannerViewController.HUDView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
    }];
}

- (void)lightenScreen {
    [UIView animateWithDuration:0.2 animations:^{
        self.scannerViewController.HUDView.backgroundColor = [UIColor clearColor];
    }];
}


- (void)showResult:(double)result {
    NSString *resultString = [NSString stringWithFormat:@"Blurriness = %0.0f%%", result * 100.0f];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Blurriness Estimation"
                                                                   message:resultString
                                                           preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
        [weakSelf lightenScreen];
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
 }


// MARK: - Picker
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [weakSelf lightenScreen];
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = (UIImage *)info[UIImagePickerControllerOriginalImage];
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [weakSelf estimateAndShowResultsWithImage:image];
    }];
}

// MARK: - Scanner delegate
- (BOOL)scannerControllerShouldAnalyseVideoFrame:(SBSDKScannerViewController *)controller {
    return NO;
}

- (void)scannerControllerWillCaptureStillImage:(SBSDKScannerViewController *)controller {
    [self darkenScreen];
}

- (void)scannerController:(nonnull SBSDKScannerViewController *)controller didCaptureImage:(nonnull UIImage *)image {
    [self estimateAndShowResultsWithImage:image];
}

- (void)scannerController:(SBSDKScannerViewController *)controller didFailCapturingImage:(NSError *)error {
    [self lightenScreen];
}
@end
