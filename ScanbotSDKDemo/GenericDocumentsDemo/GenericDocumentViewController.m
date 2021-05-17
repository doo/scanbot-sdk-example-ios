//
//  GenericDocumentViewController.m
//  SBSDK Internal Demo
//
//  Created by Sebastian Husche on 22.05.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

@import ScanbotSDK;
#import "GenericDocumentViewController.h"
#import "GenericDocumentResultViewController.h"


@interface GenericDocumentViewController () <SBSDKGenericDocumentRecognizerViewControllerDelegate, UINavigationControllerDelegate,
UIImagePickerControllerDelegate>

@property (nonatomic, strong) SBSDKGenericDocumentRecognizerViewController *scannerViewController;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end

@implementation GenericDocumentViewController

- (NSArray <SBSDKGenericDocumentRootType *>*)documentTypes {
    return [SBSDKGenericDocumentRootType allDocumentTypes];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scannerViewController =
    [[SBSDKGenericDocumentRecognizerViewController alloc] initWithParentViewController:self
                                                                            parentView:self.view
                                                                 acceptedDocumentTypes:[self documentTypes]
                                                                              delegate:self];
    
    self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicator.hidden = YES;
    [self.view addSubview:self.indicator];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.indicator.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
}

- (void)documentRecognizerViewController:(nonnull SBSDKGenericDocumentRecognizerViewController *)controller
                    didRecognizeDocument:(nonnull SBSDKGenericDocument *)document
                                 onImage:(nonnull UIImage *)image {
    
    self.indicator.hidden = YES;
    [self.indicator stopAnimating];

    [self displayResult:document withSourceImage:image];

}

- (void)displayResult:(SBSDKGenericDocument *)document withSourceImage:(UIImage *)sourceImage {
    
    if (document != nil && self.navigationController.topViewController == self) {
        GenericDocumentResultViewController *resultsVC = [GenericDocumentResultViewController makeWithResult:document
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
        SBSDKGenericDocumentRecognizer *recognizer =
        [[SBSDKGenericDocumentRecognizer alloc] initWithAcceptedDocumentTypes:[self documentTypes]];
        
        SBSDKGenericDocument *document = [recognizer recognizeDocumentOnImage:image];
        [self displayResult:document withSourceImage:image];
    }];
}

@end
