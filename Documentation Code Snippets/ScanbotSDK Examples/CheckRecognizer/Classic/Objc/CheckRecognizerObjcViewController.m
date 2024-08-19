//
//  CheckRecognizerObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 27.04.22.
//

#import "CheckRecognizerObjcViewController.h"
@import ScanbotSDK;

@interface CheckRecognizerObjcViewController () <SBSDKCheckRecognizerViewControllerDelegate>

// The instance of the recognizer view controller.
@property (strong, nonatomic) SBSDKCheckRecognizerViewController *recognizerViewController;

// The label to present the recognition status updates.
@property (nonatomic, strong) IBOutlet  UILabel *statusLabel;

@end

@implementation CheckRecognizerObjcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Create the SBSDKCheckRecognizerViewController instance.
    self.recognizerViewController = [[SBSDKCheckRecognizerViewController alloc] initWithParentViewController:self
                                                                                                  parentView:self.view
                                                                                                    delegate:self];
}

- (void)checkRecognizerViewController:(nonnull SBSDKCheckRecognizerViewController *)controller
                    didRecognizeCheck:(nonnull SBSDKCheckRecognizerResult *)result {
    // Process the recognized result.
}

- (void)checkRecognizerViewController:(nonnull SBSDKCheckRecognizerViewController *)controller
                       didChangeState:(SBSDKCheckRecognizerState)state {
    
    // Update status label according to status
    switch (state) {
        case SBSDKCheckRecognizerStateSearching:
            self.statusLabel.text = @"Looking for the check";
            break;
        case SBSDKCheckRecognizerStateRecognizing:
            self.statusLabel.text = @"Recognizing the check";
            break;
        case SBSDKCheckRecognizerStateCapturing:
            self.statusLabel.text = @"Capturing the check";
            break;
        case SBSDKCheckRecognizerStateEnergySaving:
            self.statusLabel.text = @"Energy saving mode";
            break;
        case SBSDKCheckRecognizerStatePaused:
            self.statusLabel.text = @"Recognition paused";
            break;
    }
}

@end
