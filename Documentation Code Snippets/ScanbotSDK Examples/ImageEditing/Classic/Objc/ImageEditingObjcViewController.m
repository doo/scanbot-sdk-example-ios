//
//  ImageEditingObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 09.09.21.
//

#import "ImageEditingObjcViewController.h"
@import ScanbotSDK;

@interface ImageEditingObjcViewController () <SBSDKImageEditingViewControllerDelegate>

// Image to edit.
@property (strong, nonatomic) UIImage *editingImage;

@end

@implementation ImageEditingObjcViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    SBSDKDocumentPage *page = [[SBSDKDocumentPage alloc] initWithImage:self.editingImage
                                                               polygon:nil
                                                                filter:SBSDKImageFilterTypeNone];
    
    // Create editing view controller.
    SBSDKImageEditingViewController *viewController = [SBSDKImageEditingViewController createWithPage:page];

    // Set self as a delegate.
    viewController.delegate = self;

    // Create and set up a navigation controller to present control buttons.
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    navigationController.modalPresentationStyle = UIModalPresentationFullScreen;

    // Present editing screen modally.
    [self presentViewController:navigationController animated:YES completion:nil];
}

// Create a custom cancel button.
- (UIBarButtonItem *)imageEditingViewControllerCancelButtonItem:(SBSDKImageEditingViewController *)editingViewController {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel menu:nil];
}

// Create a custom save button.
- (UIBarButtonItem *)imageEditingViewControllerApplyButtonItem:(SBSDKImageEditingViewController *)editingViewController {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave menu:nil];
}

// Create a custom button for clockwise rotation.
- (UIBarButtonItem *)imageEditingViewControllerRotateClockwiseToolbarItem:(SBSDKImageEditingViewController *)editingViewController {
    return [[UIBarButtonItem alloc] initWithTitle:@"Rotate clockwise"
                                            style:UIBarButtonItemStylePlain
                                           target:nil
                                           action:NULL];
}

// Create a custom button for counter-clockwise rotation.
- (UIBarButtonItem *)imageEditingViewControllerRotateCounterClockwiseToolbarItem:(SBSDKImageEditingViewController *)editingViewController {
    return [[UIBarButtonItem alloc] initWithTitle:@"Rotate counter-clockwise"
                                            style:UIBarButtonItemStylePlain
                                           target:nil
                                           action:NULL];
}

// Handle canceling the changes.
- (void)imageEditingViewControllerDidCancelChanges:(SBSDKImageEditingViewController *)editingViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Handle applying the changes.
- (void)imageEditingViewController:(SBSDKImageEditingViewController *)editingViewController
        didApplyChangesWithPolygon:(SBSDKPolygon *)polygon croppedImage:(UIImage *)croppedImage {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
