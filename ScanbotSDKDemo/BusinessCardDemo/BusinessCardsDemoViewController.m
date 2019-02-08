//
//  MODemoViewController.m
//  SBSDK Internal Demo
//
//  Created by Yevgeniy Knizhnik on 11/28/18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import "BusinessCardsDemoViewController.h"
#import "BusinessCardDetailDemoViewController.h"
#import "BusinessCardDemoCell.h"

@import ScanbotSDK;

@interface BusinessCardsDemoViewController () <SBSDKMultipleObjectScannerViewControllerDelegate,
UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) SBSDKMultipleObjectScannerViewController *scannerController;
@property (nonatomic, strong) SBSDKBusinessCardsImageProcessor *imageProcessor;

@property (nonatomic, strong) BusinessCard* selectedCard;

@property (nonatomic, strong) NSArray<SBSDKOCRResult *> *ocrResults;
@property (nonatomic, strong) SBSDKIndexedImageStorage *storage;
@property (nonatomic) BOOL isProcessing;

@property (strong, nonatomic) IBOutlet UIButton *closeCollectionContainerButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionContainerHeightConstraint;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@end

@implementation BusinessCardsDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageProcessor = [[SBSDKBusinessCardsImageProcessor alloc] init];
    self.scannerController = [[SBSDKMultipleObjectScannerViewController alloc] initWithParentViewController:self
                                                                                                 parentView:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[BusinessCardDetailDemoViewController class]]) {
        BusinessCardDetailDemoViewController* destinationViewController
        = (BusinessCardDetailDemoViewController *)segue.destinationViewController;
        destinationViewController.businessCard = self.selectedCard;
    }
}

- (void)processDetectedDocumentsInStorage:(SBSDKIndexedImageStorage *)storage {
    [self showLoadingView];
    self.isProcessing = YES;
    __weak __typeof(self) weakSelf = self;
    [self.imageProcessor processImageStorage:storage
                                ocrLanguages:nil
                                  completion:^(id<SBSDKImageStoring> processedStorage,
                                               NSArray<SBSDKOCRResult *> *results) {
                                      __typeof(self) strongSelf = weakSelf;
                                      strongSelf.storage = nil;
                                      strongSelf.storage = processedStorage;
                                      strongSelf.ocrResults = results;
                                      [strongSelf.collectionView reloadData];
                                      [strongSelf hideLoadingView];
                                      if (processedStorage.imageCount > 0) {
                                          [strongSelf openCollectionContainer];
                                      }
                                      strongSelf.isProcessing = NO;
    }];
}

- (void)openCollectionContainer {
    self.collectionContainerHeightConstraint.constant = 450;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)closeCollectionContainer {
    self.collectionContainerHeightConstraint.constant = 0;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)showLoadingView {
    self.loadingView.alpha = 0.0;
    [self.loadingView setHidden:NO];
    [UIView animateWithDuration:0.2 animations:^{
        self.loadingView.alpha = 1.0;
    }];
}

- (void)hideLoadingView {
    [UIView animateWithDuration:0.2 animations:^{
        self.loadingView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.loadingView setHidden:YES];
    }];
}

- (BOOL)isPanelOpened {
    return self.collectionContainerHeightConstraint.constant > 0;
}

- (IBAction)closeCollectionContainerTapped:(id)sender {
    [self closeCollectionContainer];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BusinessCardDemoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BusinessCardCell"
                                                                        forIndexPath:indexPath];
    cell.image = [self.storage imageAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.storage imageCount];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImage *image = [self.storage imageAtIndex:indexPath.row];
    NSString *text = [self.ocrResults[indexPath.row] recognizedText];
    self.selectedCard = [[BusinessCard alloc] initWith:image recognizedText:text];
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void)scannerController:(SBSDKMultipleObjectScannerViewController *)controller
  didCaptureOriginalImage:(UIImage *)originalImage { }

- (void)scannerController:(SBSDKMultipleObjectScannerViewController *)controller
didCaptureObjectImagesInStorage:(id<SBSDKImageStoring>)imageStorage {
    [self processDetectedDocumentsInStorage:imageStorage];
}

- (void)scannerControllerWillCaptureImage:(SBSDKMultipleObjectScannerViewController *)controller {
    [self.storage removeAllImages];
}

- (BOOL)scannerControllerShouldAnalyseVideoFrame:(SBSDKMultipleObjectScannerViewController *)controller {
    return [self isPanelOpened] == NO && self.isProcessing == NO;
}

@end
