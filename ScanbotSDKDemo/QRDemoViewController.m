//
//  QRDemoViewController.m
//  SBSDK Internal Demo
//
//  Created by Yevgeniy Knizhnik on 10/10/17.
//  Copyright © 2017 doo GmbH. All rights reserved.
//

#import "QRDemoViewController.h"
#import "RecognizedQRCell.h"
#import "UnfoldTransition.h"
#import "QRDescriptionViewController.h"
@import ScanbotSDK;

@interface QRDemoViewController () <SBSDKScannerViewControllerDelegate, UIViewControllerTransitioningDelegate,
UITableViewDelegate, UITableViewDataSource, QRDescriptionViewControllerDelegate>
@property (strong, nonatomic) SBSDKScannerViewController *scannerViewController;
@property (assign, nonatomic) BOOL shouldDetectCodes;
@property (assign, nonatomic) BOOL isCompactMode;
@property (strong, nonatomic) NSArray<SBSDKMachineReadableCodeMetadata *> *recognizedCodes;
@property (strong, nonatomic) NSMutableArray<CAShapeLayer *> *codesHighlightingLayers;
@property (strong, nonatomic) NSArray<UIColor *> *colors;
@property (strong, nonatomic) SBSDKMachineReadableCode *selectedParsedCode;

@property (strong, nonatomic) IBOutlet UIView *overlayView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewWidthConstraint;
@property (strong, nonatomic) IBOutlet UISwitch *modeSwitcher;

@end

static CGFloat const kTableViewFullWidthValue = 256;
static CGFloat const kTableViewFullLeadingValue = 32;
static CGFloat const kTableViewCompactWidthValue = 60;
static CGFloat const kTableViewCompactLeadingValue = 8;

@implementation QRDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scannerViewController = [[SBSDKScannerViewController alloc] initWithParentViewController:self
                                                                                       parentView:nil
                                                                                     imageStorage:nil
                                                                            enableQRCodeDetection:YES];
    self.scannerViewController.delegate = self;
    self.scannerViewController.shutterButtonHidden = YES;
    self.scannerViewController.detectionStatusHidden = YES;
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //as for iOS11, maximum of 4 codes at once are detected
    self.colors = @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor brownColor]];
    self.codesHighlightingLayers = [[NSMutableArray alloc] initWithCapacity:4];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.shouldDetectCodes = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.shouldDetectCodes = YES;
}

- (void)setRecognizedCodes:(NSArray<SBSDKMachineReadableCodeMetadata *> *)recognizedCodes {
    BOOL shouldUpdate = NO;
    if (![recognizedCodes isEqualToArray:self.recognizedCodes]) {
        shouldUpdate = YES;
    }
    _recognizedCodes = recognizedCodes;
    if (shouldUpdate) {
        [self.tableView reloadData];
    }
    [self highlightCodesOnScreen];
}

- (void)setIsCompactMode:(BOOL)isCompactMode {
    _isCompactMode = isCompactMode;
    self.shouldDetectCodes = NO;
    if (isCompactMode){
        [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0]
                      withRowAnimation:UITableViewRowAnimationFade];
    }
    self.tableViewWidthConstraint.constant = isCompactMode ? kTableViewCompactWidthValue : kTableViewFullWidthValue;
    self.tableViewLeadingConstraint.constant = isCompactMode ? kTableViewCompactLeadingValue : kTableViewFullLeadingValue;
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.shouldDetectCodes = YES;
        if (!isCompactMode) {
            [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:0]
                          withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
}

- (void)highlightCodesOnScreen {
    [self removeUnnecessaryCodeHighlighting];
    [self.recognizedCodes enumerateObjectsUsingBlock:^(SBSDKMachineReadableCodeMetadata * _Nonnull metadata,
                                                       NSUInteger index,
                                                       BOOL * _Nonnull stop) {
        if (self.codesHighlightingLayers.count <= index) {
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            layer.lineWidth = 3;
            layer.strokeColor = [[[self.colors objectAtIndex:index] colorWithAlphaComponent:0.7] CGColor];
            layer.fillColor = [[[self.colors objectAtIndex:index] colorWithAlphaComponent:0.7] CGColor];
            [self.overlayView.layer addSublayer:layer];
            [self.codesHighlightingLayers addObject:layer];
        }
        CAShapeLayer *layer = [self.codesHighlightingLayers objectAtIndex:index];
        UIBezierPath *path = [self pathForHighlightingFromMetadata:metadata];
        layer.path = path.CGPath;
    }];
}

- (UIBezierPath *)pathForHighlightingFromMetadata:(SBSDKMachineReadableCodeMetadata *)metadata {
    UIBezierPath *path = [UIBezierPath bezierPath];;
    AVCaptureVideoPreviewLayer *preview = self.scannerViewController.cameraSession.previewLayer;
    
    AVMetadataMachineReadableCodeObject *transformed
    = (AVMetadataMachineReadableCodeObject *)[preview transformedMetadataObjectForMetadataObject:metadata.codeObject];
    
    NSArray *corners = transformed.corners;

    [corners enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull corner, NSUInteger index, BOOL * _Nonnull stop) {
        CGPoint point;
        if (CGPointMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)corner, &point)) {
            CGPoint translatedPoint = [preview convertPoint:point toLayer:self.overlayView.layer];
            if (index == 0) {
                [path moveToPoint:translatedPoint];
            } else {
                [path addLineToPoint:translatedPoint];
            }
        }
    }];
    [path closePath];
    return path;
}

- (void)removeUnnecessaryCodeHighlighting {
    NSMutableArray *newLayers = [[NSMutableArray alloc] initWithCapacity:self.recognizedCodes.count];
    [self.codesHighlightingLayers enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull layer,
                                                               NSUInteger index,
                                                               BOOL * _Nonnull stop) {
        if (index >= self.recognizedCodes.count) {
            [layer removeFromSuperlayer];
        } else {
            [newLayers addObject:layer];
        }
    }];
    self.codesHighlightingLayers = newLayers;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"QRDetails"]) {
        UINavigationController *nc = (UINavigationController *)[segue destinationViewController];
        QRDescriptionViewController *vc = (QRDescriptionViewController *)nc.viewControllers.firstObject;
        
        NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
        RecognizedQRCell *cell = (RecognizedQRCell *)[self.tableView cellForRowAtIndexPath:selectedIndexPath];
        vc.cornerRadius = cell.bubbleCornerRadius;
        vc.code = self.selectedParsedCode;
        vc.color = [[self.colors objectAtIndex:selectedIndexPath.row] colorWithAlphaComponent:0.2];
        
        nc.transitioningDelegate = self;
        vc.delegate = self;
    }
}

- (IBAction)switcherValueChanged:(id)sender {
    self.isCompactMode = self.modeSwitcher.isOn;
}

/**
 SBSDKScannerViewControllerDelegate
 */
#pragma mark - SBSDKScannerViewControllerDelegate

- (BOOL)scannerControllerShouldAnalyseVideoFrame:(SBSDKScannerViewController *)controller {
    return NO;
}

- (BOOL)scannerControllerShouldDetectMachineReadableCodes:(SBSDKScannerViewController *)controller {
    return self.shouldDetectCodes;
}

- (void)scannerController:(SBSDKScannerViewController *)controller
didDetectMachineReadableCodes:(NSArray<SBSDKMachineReadableCodeMetadata *> *)codes {

    self.recognizedCodes = codes;
}

- (BOOL)scannerController:(SBSDKScannerViewController *)controller
shouldRotateInterfaceForDeviceOrientation:(UIDeviceOrientation)orientation
                transform:(CGAffineTransform)transform {
    return YES;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SBSDKMachineReadableCodeMetadata *code = [self.recognizedCodes objectAtIndex:indexPath.row];
    RecognizedQRCell *cell = (RecognizedQRCell *)[tableView dequeueReusableCellWithIdentifier:@"RecognizedQRCell"
                                                                                 forIndexPath:indexPath];
    cell.infoText = self.isCompactMode ? [SBSDKMachineReadableCodeManager.defaultManager
                                           parseCodeFromMetadata:code].type : code.stringValue;
    
    cell.bubbleColor = [[self.colors objectAtIndex:indexPath.row] colorWithAlphaComponent:0.2];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recognizedCodes.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedParsedCode = [SBSDKMachineReadableCodeManager.defaultManager
                               parseCodeFromMetadata:[self.recognizedCodes objectAtIndex:indexPath.row]];
    [self performSegueWithIdentifier:@"QRDetails" sender:self];
    self.shouldDetectCodes = NO;
    [UIView animateWithDuration:0.22 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.tableView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.recognizedCodes = @[];
    }];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
    RecognizedQRCell *cell = (RecognizedQRCell *)[self.tableView cellForRowAtIndexPath:selectedIndexPath];
    CGRect frame = [cell convertRect:cell.bubbleRect toView:self.view];
    CGFloat cornerRadius = cell.bubbleCornerRadius;
    UIColor *color = [[self.colors objectAtIndex:selectedIndexPath.row] colorWithAlphaComponent:0.2];
    UnfoldTransition *transition = [[UnfoldTransition alloc] initWithFrame:frame cornerRadius:cornerRadius color:color];
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
    return transition;
}

#pragma mark - QRDescriptionViewControllerDelegate
- (void)qrDescriptionViewControllerWillDissmiss:(QRDescriptionViewController *)viewController {
    self.tableView.alpha = 1.0;
    self.shouldDetectCodes = YES;
}

@end
