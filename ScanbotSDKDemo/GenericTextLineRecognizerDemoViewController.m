//
//  GenericTextLineRecognizerDemoViewController.m
//  SBSDK Internal Demo
//
//  Created by Andrew Petrus on 31.07.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

#import "GenericTextLineRecognizerDemoViewController.h"

@import ScanbotSDK;

@interface GenericTextLineRecognizerDemoViewController()<SBSDKGenericTextLineRecognizerViewControllerDelegate>
@property (nonatomic, strong) SBSDKGenericTextLineRecognizerViewController *textLineRecognizerController;
@property (atomic, assign) BOOL shouldRecognize;
@property (nonatomic, strong) IBOutlet UIView *cameraContainer;
@property (nonatomic, strong) IBOutlet UILabel *resultLabel;
@property (nonatomic, strong) IBOutlet UIButton *zoomButton;
@end

@implementation GenericTextLineRecognizerDemoViewController

- (void)initializeRecognizerVC {
    SBSDKGenericTextLineRecognizerConfiguration *configuration
    = [SBSDKGenericTextLineRecognizerConfiguration defaultConfiguration];
    
    // Use german and english text recognition language
    configuration.textRecognitionLanguages = @"en+de";

    // Create character set to filter results: here only alphanumerics, white space and punctuation is allowed.
    NSMutableCharacterSet * set = [NSMutableCharacterSet alphanumericCharacterSet];
    [set formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
    [set formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
    [set invert];
    
    // Filter empty words
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedObject, NSDictionary<NSString *,id> *bindings) {
        return evaluatedObject.length > 0;
    }];

    // Setup text sanitizing.
    SBSDKTextLineRecognizerTextSanitizerBlock sanitizerBlock = ^NSString*(NSString *rawText) {
        NSArray *components = [rawText componentsSeparatedByCharactersInSet:set];
        components = [components filteredArrayUsingPredicate:predicate];
        return [components componentsJoinedByString:@""];
    };
    configuration.stringSanitizerBlock = sanitizerBlock;
        
    // Create recognizer viewcontroller and make itself embed into self
    self.textLineRecognizerController
    = [[SBSDKGenericTextLineRecognizerViewController alloc] initWithParentViewController:self
                                                                              parentView:self.cameraContainer
                                                                           configuration:configuration
                                                                   preferredFinderHeight:40.0f
                                                                       finderAspectRatio:5.0
                                                                                delegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeRecognizerVC];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.shouldRecognize = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.shouldRecognize = NO;
}

- (void)showResult:(SBSDKGenericTextLineRecognizerResult *)result {
    self.resultLabel.textColor = result.validationSuccessful ? [UIColor greenColor] : [UIColor redColor];
    self.resultLabel.text = result.text;
}

- (IBAction)toggleZoom:(id)sender {
    [self.textLineRecognizerController toggleZoom:sender];
}

- (BOOL)textLineRecognizerViewControllerShouldRecognize:(SBSDKGenericTextLineRecognizerViewController *)controller {
    return self.shouldRecognize;
}

- (void)textLineRecognizerViewController:(SBSDKGenericTextLineRecognizerViewController *)controller
                       didValidateResult:(SBSDKGenericTextLineRecognizerResult *)result {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showResult:result];
    });
}

@end
