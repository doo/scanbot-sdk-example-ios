//
//  AdjustableFiltersTableViewController.m
//  ScanbotSDKDemo
//
//  Created by Danil Voitenko on 30.01.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

#import "AdjustableFiltersTableViewController.h"
#import "FilterModel.h"
#import "FilterTableViewCell.h"
@import ScanbotSDK;

@interface AdjustableFiltersTableViewController () <UINavigationControllerDelegate,
UIImagePickerControllerDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIImageView *leftResultImageView;
@property (strong, nonatomic) IBOutlet UIImageView *rightResultImageView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *leftIndicator;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *rightIndicator;
@property (strong, nonatomic) IBOutlet UILabel *leftLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightLabel;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) SBSDKBrightnessFilter *brightnessFilter;
@property (strong, nonatomic) SBSDKContrastFilter *contrastFilter;
@property (strong, nonatomic) SBSDKSaturationFilter *saturationFilter;
@property (strong, nonatomic) SBSDKVibranceFilter *vibranceFilter;
@property (strong, nonatomic) SBSDKTemperatureFilter *temperatureFilter;
@property (strong, nonatomic) SBSDKTintAdjustFilter *tintFilter;
@property (strong, nonatomic) SBSDKSpecialContrastFilter *specialContrastFilter;
@property (strong, nonatomic) SBSDKWhiteAndBlackPointFilter *whiteAndBlackPointFilter;
@property (strong, nonatomic) SBSDKShadowsHighlightsFilter *shadowsHighlightsFilter;
@property (strong, nonatomic) SBSDKSmartFilter *smartFilter;

@property (strong, nonatomic) SBSDKCompoundFilter *compoundFilterLeft;
@property (strong, nonatomic) SBSDKCompoundFilter *compoundFilterRight;

@property (strong, nonatomic) UIImage *selectedImage;

@property (strong, nonatomic) dispatch_queue_t rightFilteringQueue;
@property (strong, nonatomic) dispatch_queue_t leftFilteringQueue;

@property (assign, nonatomic) SBSDKFilterMethod leftMethod;
@property (assign, nonatomic) SBSDKFilterMethod rightMethod;

@property (strong, nonatomic) NSMutableArray *filterModels;

@end

@implementation AdjustableFiltersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftMethod = SBSDKFilterMethodCPU;
    self.rightMethod = SBSDKFilterMethodGPUMetal;
    
    self.brightnessFilter = [[SBSDKBrightnessFilter alloc] init];
    self.contrastFilter = [[SBSDKContrastFilter alloc] init];
    self.saturationFilter = [[SBSDKSaturationFilter alloc] init];
    self.vibranceFilter = [[SBSDKVibranceFilter alloc] init];
    self.temperatureFilter = [[SBSDKTemperatureFilter alloc] init];
    self.tintFilter = [[SBSDKTintAdjustFilter alloc] init];
    self.specialContrastFilter = [[SBSDKSpecialContrastFilter alloc] init];
    self.whiteAndBlackPointFilter = [[SBSDKWhiteAndBlackPointFilter alloc] init];
    self.shadowsHighlightsFilter = [[SBSDKShadowsHighlightsFilter alloc] init];
    self.smartFilter = [[SBSDKSmartFilter alloc] init];
    self.smartFilter.filterType = SBSDKImageFilterTypeNone;
    
    NSArray *filters = @[self.brightnessFilter,
                         self.contrastFilter,
                         self.saturationFilter,
                         self.vibranceFilter,
                         self.temperatureFilter,
                         self.tintFilter,
                         self.specialContrastFilter,
                         self.whiteAndBlackPointFilter,
                         self.shadowsHighlightsFilter,
                         self.smartFilter];
    
    self.compoundFilterLeft = [[SBSDKCompoundFilter alloc] initWithFilters:filters];
    self.compoundFilterRight = [[SBSDKCompoundFilter alloc] initWithFilters:filters];
    
    self.leftFilteringQueue = dispatch_queue_create("net.doo.scanbotsdkdemo.filtering.left", 0);
    self.rightFilteringQueue = dispatch_queue_create("net.doo.scanbotsdkdemo.filtering.right", 0);
    
    [self buildFilterModel];
    [self updateLabels];
    [self.tableView reloadData];
}

- (NSString *)labelForMethod:(SBSDKFilterMethod)method {
    switch (method) {
        case SBSDKFilterMethodAuto:
            return @"Automatic";
        case SBSDKFilterMethodCPU:
            return @"CPU";
        case SBSDKFilterMethodGPUMetal:
            return @"GPU Metal";
        case SBSDKFilterMethodGPUOpenGL:
            return @"GPU OpenGLES";
    }
}

- (void)updateLabels {
    self.leftLabel.text = [self labelForMethod:self.leftMethod];
    self.rightLabel.text = [self labelForMethod:self.rightMethod];
}

- (void)buildFilterModel {
    self.filterModels = [NSMutableArray arrayWithCapacity:20];
    
    FilterModel *brightness = [[FilterModel alloc] initWithName:@"Brightness" changeHandler:^(CGFloat value) {
        self.brightnessFilter.brightness = value;
        [self updateImages];
    }];
    
    FilterModel *contrast = [[FilterModel alloc] initWithName:@"Contrast" changeHandler:^(CGFloat value) {
        self.contrastFilter.contrast = value;
        [self updateImages];
    }];

    FilterModel *saturation = [[FilterModel alloc] initWithName:@"Saturation" changeHandler:^(CGFloat value) {
        self.saturationFilter.saturation = value;
        [self updateImages];
    } minValue:-1.0 maxValue:1.0];

    FilterModel *vibrance = [[FilterModel alloc] initWithName:@"Vibrance" changeHandler:^(CGFloat value) {
        self.vibranceFilter.vibrance = value;
        [self updateImages];
    } minValue:-1.0 maxValue:1.0];

    FilterModel *temperature = [[FilterModel alloc] initWithName:@"Temperature" changeHandler:^(CGFloat value) {
        self.temperatureFilter.temperature = value;
        [self updateImages];
    } minValue:-1.0 maxValue:1.0];

    FilterModel *tint = [[FilterModel alloc] initWithName:@"Tint" changeHandler:^(CGFloat value) {
        self.tintFilter.tint = value;
        [self updateImages];
    } minValue:-1.0 maxValue:1.0];


    FilterModel *blackPoint = [[FilterModel alloc] initWithName:@"Black Point" changeHandler:^(CGFloat value) {
        self.whiteAndBlackPointFilter.blackPointOffset = value;
        [self updateImages];
    } minValue:-1.0 maxValue:1.0];

    FilterModel *whitePoint = [[FilterModel alloc] initWithName:@"White Point" changeHandler:^(CGFloat value) {
        self.whiteAndBlackPointFilter.whitePointOffset = value;
        [self updateImages];
    } minValue:-1.0 maxValue:1.0];

    FilterModel *shadows = [[FilterModel alloc] initWithName:@"Shadows" changeHandler:^(CGFloat value) {
        self.shadowsHighlightsFilter.shadows = value;
        [self updateImages];
    } minValue:-1.0 maxValue:1.0];

    FilterModel *highlights = [[FilterModel alloc] initWithName:@"Highlights" changeHandler:^(CGFloat value) {
        self.shadowsHighlightsFilter.highlights = value;
        [self updateImages];
    } minValue:-1.0 maxValue:1.0];

    FilterModel *specialContrast = [[FilterModel alloc] initWithName:@"Special Contrast" changeHandler:^(CGFloat value) {
        self.specialContrastFilter.amount = value;
        [self updateImages];
    } minValue:-1.0 maxValue:1.0];
    
    [self.filterModels addObject:brightness];
    [self.filterModels addObject:contrast];
    [self.filterModels addObject:saturation];
    [self.filterModels addObject:vibrance];
    [self.filterModels addObject:temperature];
    [self.filterModels addObject:tint];
    [self.filterModels addObject:blackPoint];
    [self.filterModels addObject:whitePoint];
    [self.filterModels addObject:shadows];
    [self.filterModels addObject:highlights];
    [self.filterModels addObject:specialContrast];
}

- (void)applyFilterChain {
    dispatch_async(self.rightFilteringQueue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.rightIndicator startAnimating];
        });
        UIImage *rightResult = [self.compoundFilterRight runFilterOnImage:self.selectedImage
                                                          preferredMethod:self.rightMethod];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.rightResultImageView.image = rightResult;
            [self.rightIndicator stopAnimating];
        });
    });
    
    dispatch_async(self.leftFilteringQueue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.leftIndicator startAnimating];
        });
        UIImage *leftResult = [self.compoundFilterLeft runFilterOnImage:self.selectedImage
                                                        preferredMethod:self.leftMethod];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.leftResultImageView.image = leftResult;
            [self.leftIndicator stopAnimating];
        });
    });
}

- (void)updateImages {
    if (!self.selectedImage) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(applyFilterChain) object:nil];
    [self performSelector:@selector(applyFilterChain) withObject:nil afterDelay:0.2];
}

#pragma mark - Actions

- (IBAction)importPhotoButtonTouchUpInside:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker
                       animated:YES
                     completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    self.selectedImage = (UIImage *)info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:^{
        [self updateImages];
    }];
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filterModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterCell" forIndexPath:indexPath];
    cell.filterModel = self.filterModels[indexPath.row];
    return cell;
}

@end
