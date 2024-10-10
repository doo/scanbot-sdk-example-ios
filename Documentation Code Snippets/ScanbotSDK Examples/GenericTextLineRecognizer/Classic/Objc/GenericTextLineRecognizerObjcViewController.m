//
//  GenericTextLineRecognizerObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 07.06.21.
//

#import "GenericTextLineRecognizerObjcViewController.h"
@import ScanbotSDK;

@interface GenericTextLineRecognizerObjcViewController () <SBSDKGenericTextLineRecognizerViewControllerDelegate>

// The instance of the scanner view controller.
@property (strong, nonatomic) SBSDKGenericTextLineRecognizerViewController *recognizerController;

@end

@implementation GenericTextLineRecognizerObjcViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Create the default SBSDKGenericTextLineRecognizerConfiguration object.
    SBSDKGenericTextLineRecognizerConfiguration *configuration = [SBSDKGenericTextLineRecognizerConfiguration defaultConfiguration];

    // Create the SBSDKGenericTextLineRecognizerViewController instance.
    self.recognizerController = [[SBSDKGenericTextLineRecognizerViewController alloc] initWithParentViewController:self
                                                                                                        parentView:self.view
                                                                                                     configuration:configuration
                                                                                                          delegate:self];
}

- (void)textLineRecognizerViewController:(SBSDKGenericTextLineRecognizerViewController *)controller
                       didValidateResult:(SBSDKGenericTextLineRecognizerResult *)result {
    // Process the recognized result.
}

@end
