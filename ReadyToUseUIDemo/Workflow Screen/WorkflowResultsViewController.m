//
//  WorkflowResultsViewController.m
//  SBSDK Internal Demo
//
//  Created by Sebastian Husche on 20.11.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import "WorkflowResultsViewController.h"

@interface WorkflowResultsCollectionViewCell: UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation WorkflowResultsCollectionViewCell

@end


@interface WorkflowResultsViewController()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, copy) NSArray<SBSDKUIWorkflowStepResult*>* workflowResults;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *toPasteboardButton;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;

@end

@implementation WorkflowResultsViewController

+ (instancetype)instantiateWith:(NSArray<SBSDKUIWorkflowStepResult*>*) workflowResults {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    WorkflowResultsViewController *controller
    = (WorkflowResultsViewController*)[storyboard instantiateViewControllerWithIdentifier:@"WorkflowResultsViewController"];
    
    controller.workflowResults = workflowResults;
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self updateResults];
}

- (NSString *)resultsText {
    NSMutableArray *texts = [NSMutableArray arrayWithCapacity:self.workflowResults.count];
    for (SBSDKUIWorkflowStepResult *result in self.workflowResults) {
        if (result.mrzResult) {
            [texts addObject:result.mrzResult.stringRepresentationWithoutConfidence];
        }
        if (result.disabilityCertificateResult) {
            [texts addObject:result.disabilityCertificateResult.stringRepresentation];
        }
        if (result.barcodeResults.count > 0) {
            for (SBSDKMachineReadableCode *code in result.barcodeResults) {
                [texts addObject:code.stringValue];
                [texts addObject:@"\n\n"];
            }
        }
        if (result.payformResult.recognizedFields.count > 0) {
            for (SBSDKPayFormRecognizedField *field in result.payformResult.recognizedFields) {
                if (field.stringValue.length > 0) {
                    [texts addObject:field.stringValue];
                }
            }
        }
    }
    return [texts componentsJoinedByString:@"\n\n"];
}

- (void)updateResults {
    [self.collectionView reloadData];
    NSString *resultsText = [self resultsText];
    self.textView.text = resultsText;
    self.toPasteboardButton.enabled = resultsText.length > 0;
}

- (IBAction)toPasteboardButtonTapped:(id)sender {
    [UIPasteboard.generalPasteboard setString:[self resultsText]];
}

- (IBAction)closeButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.workflowResults.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WorkflowResultsCollectionViewCell *cell =
    (WorkflowResultsCollectionViewCell*)[collectionView
                                         dequeueReusableCellWithReuseIdentifier:@"resultsCell" forIndexPath:indexPath];
    
    SBSDKUIWorkflowStepResult *result = self.workflowResults[indexPath.item];
    UIImage *image = [result thumbnail];
    if (image == nil && result.step.acceptedMachineCodeTypes.count > 0) {
        image = [UIImage imageNamed:@"Scanbot QRCode"];
    }
    cell.imageView.image = image;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat totalWidth = collectionView.frame.size.width - 32.0f;
    CGFloat cellWidth = 128.0f;
    NSUInteger numItems = self.workflowResults.count;
    
    if (numItems == 1) {
        cellWidth = totalWidth;
    } else {
        CGFloat spacing = (numItems - 1) * 10.0f;
        cellWidth = (totalWidth - spacing) / numItems;
        cellWidth = MAX(128.0f, cellWidth);
    }
    return CGSizeMake(cellWidth, 128);
}

@end
