//
//  FilteringViewController.m
//  ScanbotSDKBeta
//
//  Created by Sebastian Husche on 19.06.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import "FilteringViewController.h"
@import ScanbotSDK;

@interface FilteringViewController ()
@property (strong, nonatomic) FilteringScreenConfiguration *configuration;
@property (strong, nonatomic) SBSDKUIPage *currentPage;
@property (assign, nonatomic) SBSDKImageFilterType selectedFilter;

@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *topBarView;
@property (strong, nonatomic) IBOutlet UIView *bottomBarView;
@property (strong, nonatomic) IBOutlet UIButton *selectFilterButton;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) dispatch_queue_t filterQueue;
@end

@implementation FilteringViewController
@synthesize currentPage = _currentPage;
@synthesize selectedFilter = _selectedFilter;

+ (nonnull instancetype)presentOn:(nonnull UIViewController *)presenter
                         withPage:(nonnull SBSDKUIPage *)page
                withConfiguration:(nonnull FilteringScreenConfiguration *)configuration
                      andDelegate:(nullable id<FilteringViewControllerDelegate>)delegate {
    
    FilteringViewController *viewController = [self createNewWithPage:page
                                                          withConfiguration:configuration
                                                                andDelegate:delegate];
    
    [presenter presentViewController:viewController animated:YES completion:nil];
    return viewController;
}

+ (nonnull instancetype)createNewWithPage:(nonnull SBSDKUIPage *)page
                        withConfiguration:(nonnull FilteringScreenConfiguration *)configuration
                              andDelegate:(nullable id<FilteringViewControllerDelegate>)delegate {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:[NSBundle bundleForClass:[self class]]];
    FilteringViewController *viewController =
    [storyboard instantiateViewControllerWithIdentifier:@"FilteringViewController"];
    viewController.statusBarStyle = UIStatusBarStyleLightContent;
    viewController.shouldShowStatusBar = YES;
    viewController.shouldHideHomeIndicator = NO;
    viewController.delegate = delegate;
    viewController.configuration = configuration;
    viewController.currentPage = page;
    return viewController;
}

- (void)setCurrentPage:(SBSDKUIPage *)currentPage {
    _currentPage = currentPage;
    _selectedFilter = (_currentPage != nil) ? _currentPage.filter : SBSDKImageFilterTypeNone;
    [self updateUI];
}

- (SBSDKUIPage *)currentPage {
    return _currentPage;
}

- (SBSDKImageFilterType)selectedFilter {
    return _selectedFilter;
}

- (void)setSelectedFilter:(SBSDKImageFilterType)selectedFilter {
    if (_selectedFilter != selectedFilter) {
        _selectedFilter = selectedFilter;
        [self updateUI];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.filterQueue = dispatch_queue_create("page.filtering", DISPATCH_QUEUE_SERIAL);
    [self configureUI];
    [self updateUI];
}

- (void)configureUI {
    
    self.titleLabel.textColor = self.configuration.uiConfiguration.titleColor;
    self.titleLabel.text = self.configuration.textConfiguration.topBarTitle;
    self.topBarView.backgroundColor = self.configuration.uiConfiguration.topBarBackgroundColor;
    
    [self.cancelButton setTitleColor:self.configuration.uiConfiguration.topBarButtonsColor
                            forState:UIControlStateNormal];
    [self.cancelButton setTitle:self.configuration.textConfiguration.cancelButtonTitle forState:UIControlStateNormal];
    
    [self.doneButton setTitleColor:self.configuration.uiConfiguration.topBarButtonsColor forState:UIControlStateNormal];
    [self.doneButton setTitle:self.configuration.textConfiguration.doneButtonTitle forState:UIControlStateNormal];
    
    [self.bottomBarView setBackgroundColor:self.configuration.uiConfiguration.bottomBarBackgroundColor];
    [self.selectFilterButton setTitleColor:self.configuration.uiConfiguration.bottomBarButtonsColor
                                  forState:UIControlStateNormal];
    [self.selectFilterButton setTitle:self.configuration.textConfiguration.filterButtonTitle
                             forState:UIControlStateNormal];
    
    [self.activityIndicator setColor:self.configuration.uiConfiguration.activityIndicatorColor];
    
    self.view.backgroundColor = self.configuration.uiConfiguration.backgroundColor;
}

- (void)updateUI {
    if (!self.isViewLoaded) {
        return;
    }
    [self.activityIndicator startAnimating];
    self.imageView.image = nil;
    SBSDKImageFilterType filter = self.selectedFilter;
    dispatch_async(self.filterQueue, ^{
        UIImage *filteredImage = [self.currentPage documentPreviewImageUsingFilter:filter];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = filteredImage;
            [self.activityIndicator stopAnimating];
        });
    });
    [self.selectFilterButton setTitle:[self nameForFilter:self.selectedFilter] forState:UIControlStateNormal];
}

- (void)didCancel {
    if ([self.delegate respondsToSelector:@selector(filteringViewControllerDidCancel:)]) {
        [self.delegate filteringViewControllerDidCancel:self];
    }
}

- (void)didFinish {
    if ([self.delegate respondsToSelector:@selector(filteringViewController:didFinish:)]) {
        [self.delegate filteringViewController:self didFinish:self.currentPage];
    }
}

- (IBAction)cancelButtonTapped:(UIButton *)sender {
    [self dismiss:YES];
}

- (IBAction)doneButtonTapped:(UIButton *)sender {
    self.currentPage.filter = self.selectedFilter;
    [self dismiss:self.currentPage == nil];
}

- (NSString *)nameForFilter:(SBSDKImageFilterType)filter {
    switch(filter) {
        case SBSDKImageFilterTypeNone:
            return @"SBSDKImageFilterTypeNone";
        case SBSDKImageFilterTypeColor:
            return @"SBSDKImageFilterTypeColor";
        case SBSDKImageFilterTypeGray:
            return @"SBSDKImageFilterTypeGray";
        case SBSDKImageFilterTypeBinarized:
            return @"SBSDKImageFilterTypeBinarized";
        case SBSDKImageFilterTypeColorDocument:
            return @"SBSDKImageFilterTypeColorDocument";
        case SBSDKImageFilterTypePureBinarized:
            return @"SBSDKImageFilterTypePureBinarized";
        case SBSDKImageFilterTypeBackgroundClean:
            return @"SBSDKImageFilterTypeBackgroundClean";
        case SBSDKImageFilterTypeBlackAndWhite:
            return @"SBSDKImageFilterTypeBlackAndWhite";
        default:
            return [NSString stringWithFormat:@"Filter No. %lu", (NSUInteger)filter];
    }
}

- (UIAlertAction *)actionForFilter:(SBSDKImageFilterType)filter {
    UIAlertAction *action = [UIAlertAction actionWithTitle:[self nameForFilter:filter]
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       [self setSelectedFilter:filter];
                                                   }];
    return action;
}

- (UIAlertAction *)cancelAction {
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) { }];
    return action;
}

- (IBAction)selectFilterButtonTapped:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Filter Page"
                                                                   message:@"Select your filter."
                                                            preferredStyle:UIAlertControllerStyleActionSheet];

    [alert addAction:[self actionForFilter:SBSDKImageFilterTypeNone]];
    [alert addAction:[self actionForFilter:SBSDKImageFilterTypeColor]];
    [alert addAction:[self actionForFilter:SBSDKImageFilterTypeGray]];
    [alert addAction:[self actionForFilter:SBSDKImageFilterTypeBinarized]];
    [alert addAction:[self actionForFilter:SBSDKImageFilterTypeColorDocument]];
    [alert addAction:[self actionForFilter:SBSDKImageFilterTypePureBinarized]];
    [alert addAction:[self actionForFilter:SBSDKImageFilterTypeBackgroundClean]];
    [alert addAction:[self actionForFilter:SBSDKImageFilterTypeBlackAndWhite]];
    
    [alert addAction:[self cancelAction]];
    
    [self presentViewController:alert animated:YES completion:nil];
}


@end
