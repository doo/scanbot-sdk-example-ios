//
//  TextViewController.m
//  PayFormScannerDemo
//
//  Created by Sebastian Husche on 24.06.15.
//  Copyright (c) 2015 doo GmbH. All rights reserved.
//

#import "TextViewController.h"

@interface TextViewController ()
@property (strong, nonatomic) IBOutlet UITextView *textView;

@end

@implementation TextViewController

+ (TextViewController *)textControllerWithText:(NSString *)text {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TextViewController  *textViewController = (TextViewController *)[storyBoard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    textViewController.textToDisplay = text;
    return textViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateText];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)setTextToDisplay:(NSString *)textToDisplay {
    _textToDisplay = [textToDisplay copy];
    [self updateText];
}

- (void)updateText {
    if (self.isViewLoaded) {
        self.textView.text = self.textToDisplay;
    }
}

@end
