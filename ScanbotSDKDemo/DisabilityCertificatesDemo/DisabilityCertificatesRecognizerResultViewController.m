//
//  DisabilityCertificatesRecognizerResultViewController.m
//  ScanbotSDKDemo
//
//  Created by Andrew Petrus on 15.02.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import "DisabilityCertificatesRecognizerResultViewController.h"
#import "DisabilityCertificatesResultsImageTableViewCell.h"
#import "DisabilityCertificatesResultsCheckboxesInfoTableViewCell.h"
#import "DisabilityCertificatesResultsDatesInfoTableViewCell.h"

@import ScanbotSDK;

@interface DisabilityCertificatesRecognizerResultViewController () <SBSDKImageEditingViewControllerDelegate>

@property (nonatomic, strong) SBSDKDisabilityCertificatesRecognizer *recognizer;
@property (nonatomic, strong) SBSDKImageEditingViewController *editingController;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet DisabilityCertificatesResultsImageTableViewCell *imageCell;
@property (weak, nonatomic) IBOutlet DisabilityCertificatesResultsCheckboxesInfoTableViewCell *checkboxesInfoCell;
@property (weak, nonatomic) IBOutlet DisabilityCertificatesResultsDatesInfoTableViewCell *datesInfoCell;

@end

@implementation DisabilityCertificatesRecognizerResultViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.recognizer = [SBSDKDisabilityCertificatesRecognizer new];
    if (self.selectedImage != nil) {
        if (self.originalImage == nil) {
            self.originalImage = self.selectedImage;
        }
        [self recognizeAUDataFromImage:self.selectedImage];
    } else {
        [self showDCRecognizerResult:nil];
    }
}

- (void)configureEditingViewController:(UIImage *)image {
    self.editingController = [SBSDKImageEditingViewController new];
    self.editingController.image = image;
    self.editingController.delegate = self;
}

- (IBAction)editImageButtonTapped:(id)sender {
    [self configureEditingViewController:self.originalImage];
    if (self.editingController) {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.editingController];
        navigationController.navigationBar.barStyle = UIBarStyleDefault;
        navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        navigationController.navigationBar.tintColor = [UIColor blackColor];
        
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

- (void)recognizeAUDataFromImage:(UIImage *)documentImage {
    [self.activityIndicator startAnimating];
    
    __block UIImage *image = documentImage;
    dispatch_async(dispatch_queue_create("net.doo.DisabilityCertificatesRecognizerDemo.recognition", NULL), ^{
        SBSDKDisabilityCertificatesRecognizerResult *result = [self.recognizer recognizeFromImage:image];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
            [self showDCRecognizerResult:result];
        });
    });
}

- (void)showDCRecognizerResult:(SBSDKDisabilityCertificatesRecognizerResult *)result {
    self.imageCell.documentImage.image = self.selectedImage;
    [self.checkboxesInfoCell updateCell:result];
    [self.datesInfoCell updateCell:result];
}

#pragma mark - SBSDKImageEditingViewControllerDelegate

- (UIBarButtonItem *)imageEditingViewControllerCancelButtonItem:(SBSDKImageEditingViewController *)editingViewController {
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ui_action_close"]
                                            style:UIBarButtonItemStylePlain
                                           target:nil
                                           action:nil];
}

- (UIBarButtonItem *)imageEditingViewControllerApplyButtonItem:(SBSDKImageEditingViewController *)editingViewController {
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ui_action_checkmark"]
                                            style:UIBarButtonItemStylePlain
                                           target:nil
                                           action:nil];
}

- (UIBarButtonItem *)imageEditingViewControllerRotateClockwiseToolbarItem:(SBSDKImageEditingViewController *)editingViewController {
    return [[UIBarButtonItem alloc] initWithTitle:@"Rotate right"
                                            style:UIBarButtonItemStylePlain
                                           target:nil
                                           action:nil];
}

- (UIBarButtonItem *)imageEditingViewControllerRotateCounterClockwiseToolbarItem:(SBSDKImageEditingViewController *)editingViewController {
    return [[UIBarButtonItem alloc] initWithTitle:@"Rotate left"
                                            style:UIBarButtonItemStylePlain
                                           target:nil
                                           action:nil];
}

- (UIBarStyle)imageEditingViewControllerToolbarStyle:(SBSDKImageEditingViewController *)editingViewController {
    return UIBarStyleDefault;
}

- (UIColor *)imageEditingViewControllerToolbarItemTintColor:(SBSDKImageEditingViewController *)editingViewController {
    return [UIColor blackColor];
}

- (UIColor *)imageEditingViewControllerToolbarTintColor:(SBSDKImageEditingViewController *)editingViewController {
    return [UIColor whiteColor];
}

- (void)imageEditingViewControllerDidCancelChanges:(SBSDKImageEditingViewController *)editingViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageEditingViewController:(SBSDKImageEditingViewController *)editingViewController didApplyChangesWithPolygon:(SBSDKPolygon *)polygon croppedImage:(UIImage *)croppedImage {
    self.selectedImage = croppedImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
