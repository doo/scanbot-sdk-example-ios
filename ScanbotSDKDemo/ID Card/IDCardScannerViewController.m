//
//  IDCardScannerViewController.m
//  SBSDK Internal Demo
//
//  Created by Sebastian Husche on 22.05.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

@import ScanbotSDK;
#import "IDCardScannerViewController.h"
#import "IDCardScannerResultViewController.h"


@interface IDCardScannerViewController () <SBSDKIDCardScannerViewControllerDelegate, UINavigationControllerDelegate,
UIImagePickerControllerDelegate>

@property (nonatomic, strong) SBSDKIDCardScannerViewController *scannerViewController;
@end

@implementation IDCardScannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scannerViewController = [[SBSDKIDCardScannerViewController alloc] initWithParentViewController:self
                                                                                             parentView:self.view
                                                                                               delegate:self];
    self.scannerViewController.useLiveRecognition = NO;
}

- (void)idCardScannerViewController:(nonnull SBSDKIDCardScannerViewController *)controller
                 didRecognizeIDCard:(nonnull SBSDKIDCardRecognizerResult *)idCardResult
                            onImage:(nonnull UIImage *)image {
    
    [self displayResult:idCardResult withSourceImage:image];
}

- (void)displayResult:(SBSDKIDCardRecognizerResult *)result withSourceImage:(UIImage *)sourceImage {
    
    if (result.recognitionSuccessful && self.navigationController.topViewController == self) {
        IDCardScannerResultViewController *resultsVC = [IDCardScannerResultViewController makeWithResult:result
                                                                                             sourceImage:sourceImage];
        
        [self.navigationController pushViewController:resultsVC animated:YES];
    }
}


- (IBAction)selectImageButtonTapped:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerController delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = (UIImage *)info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:^{
        SBSDKIDCardRecognizer *recognizer = [[SBSDKIDCardRecognizer alloc] init];
        SBSDKIDCardRecognizerResult *result = [recognizer recognizeIDCardOnImage:image];
        [self displayResult:result withSourceImage:image];
    }];
}





@end
