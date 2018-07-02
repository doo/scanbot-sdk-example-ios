//
//  PageReviewViewController.m
//  ScanbotSDK
//
//  Created by Sebastian Husche on 27.04.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import "PageReviewViewController.h"
#import "PageCollectionViewCell.h"
@import ScanbotSDK;

@interface PageReviewViewController() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching>

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UICollectionViewFlowLayout *collectionLayout;

@property (nonatomic, strong) IBOutlet UIButton *closeButton;
@property (nonatomic, strong) IBOutlet UIView *topBarView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) PageReviewScreenConfiguration *configuration;
@property (nonatomic, strong) SBSDKUIDocument *document;
@property (nonatomic, strong) NSCache *imageCache;

@end

@implementation PageReviewViewController

+ (nonnull instancetype)presentOn:(nonnull UIViewController *)presenter
                     withDocument:(nonnull SBSDKUIDocument *)document
                withConfiguration:(nonnull PageReviewScreenConfiguration *)configuration
                      andDelegate:(nullable id<PageReviewViewControllerDelegate>)delegate {
    
    PageReviewViewController *viewController = [self createNewWithDocument:document
                                                                withConfiguration:configuration
                                                                      andDelegate:delegate];
    
    [presenter presentViewController:viewController animated:YES completion:nil];
    return viewController;
}

+ (nonnull instancetype)createNewWithDocument:(nonnull SBSDKUIDocument *)document
                         withConfiguration:(nonnull PageReviewScreenConfiguration *)configuration
                               andDelegate:(nullable id<PageReviewViewControllerDelegate>)delegate {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:[NSBundle bundleForClass:[self class]]];
    PageReviewViewController *viewController =
    [storyboard instantiateViewControllerWithIdentifier:@"PageReviewViewController"];
    viewController.statusBarStyle = UIStatusBarStyleLightContent;
    viewController.shouldShowStatusBar = YES;
    viewController.shouldHideHomeIndicator = NO;
    viewController.delegate = delegate;
    viewController.configuration = configuration;
    viewController.document = document;
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageCache = [[NSCache alloc] init];
    if (@available(iOS 10, *)) {
        self.collectionView.prefetchDataSource = self;
    }
    [self configureUI];
}

- (void)configureUI {
    
    self.collectionLayout.itemSize = self.configuration.uiConfiguration.cellSize;
    
    self.titleLabel.textColor = self.configuration.uiConfiguration.titleColor;
    self.titleLabel.text = self.configuration.textConfiguration.topBarTitle;
    
    self.topBarView.backgroundColor = self.configuration.uiConfiguration.topBarColor;
    
    [self.closeButton setTitleColor:self.configuration.uiConfiguration.closeButtonColor
                            forState:UIControlStateNormal];
    
    [self.closeButton setTitle:self.configuration.textConfiguration.closeButtonTitle forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)reloadData {
    self.imageCache = [[NSCache alloc] init];
    [self.collectionView reloadData];
}

- (void)didCancel {
    if ([self.delegate respondsToSelector:@selector(pageReviewViewControllerDidCancel:)]) {
        [self.delegate pageReviewViewControllerDidCancel:self];
    }
}

- (void)didFinish {
    [self didCancel];
}

- (IBAction)closeButtonTapped:(id)sender {
    [self dismiss:NO];
}

- (UIImage *)thumbnailImageForPage:(SBSDKUIPage *)page {
    UIImage *image = [self.imageCache objectForKey:page.pageFileUUID];
    CGSize cellSize = self.configuration.uiConfiguration.cellSize;
    CGFloat size = [UIScreen mainScreen].scale * MAX(cellSize.width, cellSize.height);
    if (image == nil) {
        UIImage *previewImage = [page documentPreviewImage];
        image = [SBSDKUIPageStoragePreviewImageCreator createPreviewImageFromImage:previewImage withSideLength:size];
        if (image) {
            [self.imageCache setObject:image forKey:page.pageFileUUID];
        }
    }
    return image;
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.document.numberOfPages;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SBSDKUIPage *page = [self.document pageAtIndex:indexPath.row];
    [self.imageCache removeObjectForKey:page.pageFileUUID];
    if ([self.delegate respondsToSelector:@selector(pageReviewViewController:didSelect:)]) {
        [self.delegate pageReviewViewController:self didSelect:page];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PageCollectionViewCell *cell
    = (PageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"pageCell"
                                                                          forIndexPath:indexPath];
    SBSDKUIPage *page = [self.document pageAtIndex:indexPath.row];
    cell.imageView.image = [self thumbnailImageForPage:page];
    cell.highlightView.backgroundColor = self.configuration.uiConfiguration.cellHighlightColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath*>*)indexPaths {
    for (NSIndexPath *indexPath in indexPaths) {
        SBSDKUIPage *page = [self.document pageAtIndex:indexPath.row];
        [self thumbnailImageForPage:page];
    }
}

@end
