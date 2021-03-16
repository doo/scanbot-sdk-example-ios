//
//  LicensePlateDemoViewController.m
//  SBSDK Internal Demo
//
//  Created by Sebastian Husche on 03.03.21.
//  Copyright © 2021 doo GmbH. All rights reserved.
//

#import "LicensePlateDemoViewController.h"
@import ScanbotSDK;

@interface LicensePlateDemoViewController()<SBSDKLicensePlateScannerViewControllerDelegate>

@property(nonatomic, strong) SBSDKLicensePlateScannerViewController *scannerViewController;
@property (nonatomic, strong) IBOutlet UIView *cameraContainer;
@property (nonatomic, strong) IBOutlet UILabel *resultLabel;
@property (nonatomic, strong) IBOutlet UIImageView *resultImageView;
@end



@implementation LicensePlateDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.resultImageView.layer.cornerRadius = 8.0;
    self.resultImageView.layer.masksToBounds = YES;
    self.resultImageView.layer.borderColor = [UIColor blackColor].CGColor;
    self.resultImageView.layer.borderWidth = 4.0;
    self.resultImageView.backgroundColor = [UIColor whiteColor];
    
    [self showResult:nil];
    self.scannerViewController =
    [[SBSDKLicensePlateScannerViewController alloc] initWithParentViewController:self
                                                                      parentView:self.cameraContainer
                                                                        delegate:self
                                                                   configuration:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showResult:nil];
}

- (IBAction)tapGestureRecognized:(id)sender {
    [self showResult:nil];
}

- (void)showResult:(SBSDKLicensePlateScannerResult *)result {
    
    BOOL hasResult = result != nil;
    self.resultLabel.hidden = !hasResult;
    self.resultImageView.hidden = !hasResult;
    
    if (result != nil) {
        NSString *resultString =
        [NSString stringWithFormat:@"Country code: %@\nPlate: %@\nConfidence: %0.0f%%",
         result.countryCode,
         result.licensePlate,
         result.confidence * 100.0];
    
        if (![resultString isEqualToString:self.resultLabel.text]) {
            self.resultLabel.text = resultString;
            self.resultImageView.image = result.croppedImage;
        }
    } else {
        self.resultLabel.text = nil;
        self.resultImageView.image = nil;
    }
}

- (void)licensePlateScannerViewController:(nonnull SBSDKLicensePlateScannerViewController *)controller
                 didRecognizeLicensePlate:(nonnull SBSDKLicensePlateScannerResult *)licensePlateResult
                                  onImage:(nonnull UIImage *)image {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showResult:licensePlateResult];
    });
}

@end
