//
//  DocumentDemoViewController.m
//  ScanbotSDKDemo
//
//  Created by Sebastian Husche on 08.06.15.
//  Copyright (c) 2015 doo GmbH. All rights reserved.
//

#import "DocumentDemoViewController.h"
#import "TextViewController.h"
#import "DemoPDFViewController.h"
#import <ScanbotSDK/SBSDKCropViewController.h>

@interface DocumentDemoViewController () <SBSDKImageEditingViewControllerDelegate>
@property (strong, nonatomic) SBSDKIndexedImageStorage *documentImageStorage;
@property (strong, nonatomic) SBSDKIndexedImageStorage *originalImageStorage;
@property (strong, nonatomic) IBOutlet UIButton *actionsButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *clearButton;
@property (strong, nonatomic) IBOutlet UILabel *pageLabel;
@property (strong, nonatomic) SBSDKProgress *currentProgress;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UILabel *progressLabel;
@property (strong, nonatomic) SBSDKOpticalTextRecognizer *textRecognizer;
@property (strong, nonatomic) UIAlertController *actionController;
@property (assign, nonatomic) BOOL viewAppeared;
@property (strong, nonatomic) UIButton *myShutterButton;
@end

@implementation DocumentDemoViewController

/**
 Subclass overrides
 */
#pragma mark - Subclass overrides

- (void)viewDidLoad {
    [super viewDidLoad];

    if (![ScanbotSDK isLicenseValid]) {
        [self updateUI];
        UIAlertController *alert
        = [UIAlertController alertControllerWithTitle:@"Error"
                                              message:@"The ScanbotSDK license has been expired. Please contact the manufacturer of the app."
                                       preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        [self presentViewController:alert animated:NO completion:nil];

        return;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appTerminates:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];

    // Initialize image storages.
    //
    // For demo purposes we use two different storages:
    // - a default one for ORIGINAL (uncropped) images
    // - and a custom one for cropped DOCUMENT images.

    // Default ImageStorage for original images:
    self.originalImageStorage = [[SBSDKIndexedImageStorage alloc] init];

    // Custom ImageStorage for document images:
    // You can fetch the cropped images of this custom storage location via iTunes file sharing.
    NSURL *appDocDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString *docImagesDir = [NSString stringWithFormat:@"%@/%@", appDocDir.path, @"sbsdk-demo-document-images"];
    NSURL *docImagesDirUrl = [[NSURL alloc] initFileURLWithPath:docImagesDir isDirectory:YES];
    SBSDKStorageLocation *customStorageLocation = [[SBSDKStorageLocation alloc] initWithBaseURL:docImagesDirUrl];
    self.documentImageStorage = [[SBSDKIndexedImageStorage alloc] initWithStorageLocation:customStorageLocation];
    [self setupScannerViewController];
    
    [self updateUI];
}

- (void)setupScannerViewController {
    self.scannerViewController = [[SBSDKScannerViewController alloc] initWithParentViewController:self imageStorage:nil];
    //self.scannerViewController.shutterMode = SBSDKShutterModeSmart;
    self.scannerViewController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.viewAppeared = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.viewAppeared = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)appTerminates:(NSNotification *)notification {
    self.documentImageStorage = nil;
    self.originalImageStorage = nil;
}

/** Uncomment the following 2 methods if you want to suppress automatic interface rotations. **/
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

/** 
 SBSDKScannerViewControllerDelegate 
 */
#pragma mark - SBSDKScannerViewControllerDelegate

- (BOOL)scannerControllerShouldAnalyseVideoFrame:(SBSDKScannerViewController *)controller {
    
    BOOL hasActivity = !(controller.timeSinceLastMotion > 3.0 && controller.timeSinceLastDetectedPolygon > 1.0);
    
    return (self.viewAppeared
            && hasActivity
            && self.presentedViewController == nil
            && self.currentProgress == nil
            && self.scannerViewController.autoShutterEnabled == YES);
}

- (void)scannerController:(SBSDKScannerViewController *)controller
         didDetectPolygon:(SBSDKPolygon *)polygon
               withStatus:(SBSDKDocumentDetectionStatus)status {
    
}

- (void)scannerControllerWillCaptureStillImage:(SBSDKScannerViewController *)controller {
    // We are about to take a photo.
    // Change your UI to visualize that we are busy now.
    [UIView animateWithDuration:0.25 animations:^{
        controller.HUDView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
    }];
}

- (void)scannerController:(SBSDKScannerViewController *)controller
  didCaptureDocumentImage:(UIImage *)documentImage {
    // Successfully captured an image.
    // Here we get and store the (cropped) DOCUMENT image:
    [self.documentImageStorage addImage:documentImage];

    [self updateUI];
    [UIView animateWithDuration:0.25 animations:^{
        controller.HUDView.backgroundColor = [UIColor clearColor];
    }];
}

- (void)scannerController:(SBSDKScannerViewController *)controller didCaptureImage:(UIImage *)image {
    // Successfully captured an image.
    // Here we get and store the ORIGINAL (uncropped) image:
    [self.originalImageStorage addImage:image];
}

- (void)scannerController:(SBSDKScannerViewController *)controller didFailCapturingImage:(NSError *)error {
    // Display the error.
    // Undo all your changes to your UI that you did in -scannerControllerWillCaptureStillImage:
    [UIView animateWithDuration:0.25 animations:^{
        controller.HUDView.backgroundColor = [UIColor clearColor];
    }];
}

- (UIButton *)scannerControllerCustomShutterButton:(SBSDKScannerViewController *)controller {
    /**
     // Create a custom shutter button and return it.
     if (!self.myShutterButton) {
        UIButton *theButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
        theButton.showsTouchWhenHighlighted = YES;
        [theButton setTitle:@"Take a snap" forState:UIControlStateNormal];
        [theButton sizeToFit];
        self.myShutterButton = theButton;
        [self.myShutterButton.superview layoutIfNeeded];
    }
    return self.myShutterButton; 
    */
    return nil;
}

- (UIView *)scannerController:(SBSDKScannerViewController *)controller
       viewForDetectionStatus:(SBSDKDocumentDetectionStatus)status {
    
    return nil;
}


- (void)scannerController:(SBSDKScannerViewController *)controller
        drawPolygonPoints:(NSArray *)pointValues
      withDetectionStatus:(SBSDKDocumentDetectionStatus)detectStatus
                  onLayer:(CAShapeLayer *)layer {
    
    
    UIColor *baseColor = [UIColor colorWithRed:0.173 green:0.612 blue:0.988 alpha:1];
    CGFloat lineWidth = 0.0f;
    CGFloat alpha = 0.3f;
    if (detectStatus == SBSDKDocumentDetectionStatusOK) {
        lineWidth = 2.0f;
        alpha = 0.5f;
    }
    
    layer.lineWidth = lineWidth;
    
    // Set the stroke color for the polygon path on the layer.
    layer.strokeColor = baseColor.CGColor;
    
    // Set the fill color for the polygon path on the layer. If set to nil no fill is drawn.
    layer.fillColor = [baseColor colorWithAlphaComponent:alpha].CGColor;
    
    // Create the bezier path from the polygons points.
    UIBezierPath *path = nil;
    for (NSUInteger index = 0; index < pointValues.count; index ++) {
        if (index == 0) {
            path = [UIBezierPath bezierPath];
            [path moveToPoint:[pointValues[index] CGPointValue]];
        } else {
            [path addLineToPoint:[pointValues[index] CGPointValue]];
        }
    }
    [path closePath];
    
    // Set the layers path. This automatically animates and creates nice and fluid transition between polygons.
    layer.path = path.CGPath;
}

- (UIColor *)scannerController:(SBSDKScannerViewController *)controller
polygonColorForDetectionStatus:(SBSDKDocumentDetectionStatus)status {
    
    if (status == SBSDKDocumentDetectionStatusOK) {
        return [UIColor greenColor];
    }
    return [UIColor redColor];
}

- (BOOL)scannerController:(SBSDKScannerViewController *)controller
shouldRotateInterfaceForDeviceOrientation:(UIDeviceOrientation)orientation
                transform:(CGAffineTransform)transform {
    
    return !self.shouldAutorotate;
}

- (NSString *)scannerController:(SBSDKScannerViewController *)controller
localizedTextForDetectionStatus:(SBSDKDocumentDetectionStatus)status {
    // Here you can return custom user guidance strings depending on the current detection status.
    
    if (self.scannerViewController.energySavingActive) {
        return @"Energy saving active.\nMove your device.";
    }
    
    switch (status) {
        case SBSDKDocumentDetectionStatusOK:
            return @"Don't move. Capturing document...";
        case SBSDKDocumentDetectionStatusOK_SmallSize:
            return @"Move closer.";
        case SBSDKDocumentDetectionStatusOK_BadAngles:
            return @"Turn your device to\nhave a more rectangular outline.";
        case SBSDKDocumentDetectionStatusOK_BadAspectRatio:
            return @"Wrong aspect ratio.\n Rotate your device.";
        case SBSDKDocumentDetectionStatusOK_OffCenter:
            return @"Move to the center.";
        case SBSDKDocumentDetectionStatusError_NothingDetected:
            return @"Searching for document...";
        case SBSDKDocumentDetectionStatusError_Noise:
            return @"Background too noisy!\nSearching for document...";
        case SBSDKDocumentDetectionStatusError_Brightness:
            return @"Poor light!\nSearching for document...";
        default:
            return nil;
    }
}


/**
 UI updating
 */
#pragma mark - UI updating

- (void)setCurrentProgress:(SBSDKProgress *)currentProgress {
    if (_currentProgress != currentProgress) {
        _currentProgress.updateHandler = nil;
        _currentProgress = currentProgress;
        __weak DocumentDemoViewController *weakSelf = self;
        _currentProgress.updateHandler = ^void(SBSDKProgress *progress) {
            [weakSelf updateProgress];
        };
    }
    [self updateProgress];
    [self updateUI];
}

- (void)updateUI {
    self.pageLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.documentImageStorage.imageCount];
    BOOL hasImages = self.documentImageStorage.imageCount > 0;
    BOOL operationRunning = self.currentProgress != nil;
    self.actionsButton.hidden = operationRunning || !hasImages;
    self.progressView.hidden = !operationRunning;
    self.progressLabel.hidden = !operationRunning;
    self.cancelButton.hidden = !operationRunning;
    self.clearButton.hidden = !hasImages;
    self.scannerViewController.shutterButtonHidden = operationRunning;
    self.scannerViewController.detectionStatusHidden = operationRunning;
}

- (void)updateProgress {
    self.progressView.progress = self.currentProgress.fractionCompleted;
    self.progressLabel.text = [self.currentProgress.localizedDescription stringByAppendingFormat:@"\n%@",
                               self.currentProgress.localizedAdditionalDescription];
}




/**
 User initiated actions
 */
#pragma mark - User initiated actions

- (IBAction)clearImageStorage:(id)sender {
    [self.documentImageStorage removeAllImages];
    [self.originalImageStorage removeAllImages];
    [self updateUI];
}

- (IBAction)cancelOperation:(id)sender {
    if (!self.currentProgress.isCancelled) {
        [self.currentProgress cancel];
        [self updateUI];
    }
}

- (IBAction)openActionsMenu:(id)sender {
    if (!self.actionController) {
        self.actionController = [[UIAlertController alloc] init];
        self.actionController.title = @"Scanbot SDK - Choose an action";
        __weak DocumentDemoViewController *weakSelf = self;

        [self.actionController addAction:[UIAlertAction actionWithTitle:@"Manual Crop"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action) {
                                                                    
                                                                    [weakSelf performManualCrop:action];
                                                                    [weakSelf dismissViewControllerAnimated:YES
                                                                                                 completion:nil];
                                                                }]];
        
        [self.actionController addAction:[UIAlertAction actionWithTitle:@"PDF - No OCR"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action) {
                                                                    
                                                                    [weakSelf createPDF:action];
                                                                    [weakSelf dismissViewControllerAnimated:YES
                                                                                                 completion:nil];
                                                                }]];
        
        [self.actionController addAction:[UIAlertAction actionWithTitle:@"PDF - With OCR"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action) {
                                                                    DocumentDemoViewController *strongSelf = weakSelf;
                                                                    [strongSelf createOCRPDF:action];
                                                                    [strongSelf dismissViewControllerAnimated:YES
                                                                                                   completion:nil];
                                                                }]];
        
        [self.actionController addAction:[UIAlertAction actionWithTitle:@"OCR text - Image storage"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action) {
                                                                    DocumentDemoViewController *strongSelf = weakSelf;
                                                                    [strongSelf performOCR:action];
                                                                    [strongSelf dismissViewControllerAnimated:YES
                                                                                                   completion:nil];
                                                                }]];
        
        [self.actionController addAction:[UIAlertAction actionWithTitle:@"OCR text - Single image"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action) {
                                                                    DocumentDemoViewController *strongSelf = weakSelf;
                                                                    [strongSelf performSingleImageOCR:action];
                                                                    [strongSelf dismissViewControllerAnimated:YES
                                                                                                   completion:nil];
                                                                }]];
        
        
        [self.actionController addAction:[UIAlertAction actionWithTitle:@"Page analysis - Single image"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action) {
                                                                    DocumentDemoViewController *strongSelf = weakSelf;
                                                                    [strongSelf performPageAnalysis:action];
                                                                    [strongSelf dismissViewControllerAnimated:YES
                                                                                                   completion:nil];
                                                                }]];
        
        [self.actionController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                                  style:UIAlertActionStyleCancel
                                                                handler:^(UIAlertAction *action) {
                                                                    [weakSelf dismissViewControllerAnimated:YES
                                                                                                 completion:nil];
                                                                }]];
    }
    
    [self.actionController setModalPresentationStyle:UIModalPresentationPopover];
    
    UIPopoverPresentationController *popPresenter = [self.actionController popoverPresentationController];
    popPresenter.sourceView = sender;
    popPresenter.sourceRect = [sender bounds];
    [self presentViewController:self.actionController animated:YES completion:nil];
}

- (IBAction)createPDF:(id)sender {
    if (self.currentProgress) {
        return;
    }
    
    if (self.documentImageStorage.imageCount == 0) {
        return;
    }
    
    NSString *filename = @"ScanbotSDK_PDF.pdf";
    NSURL *pdfURL = [SBSDKStorageLocation applicationDocumentsFolderURL];
    pdfURL = [pdfURL URLByAppendingPathComponent:filename];
    
    self.currentProgress = [SBSDKPDFRenderer renderImageStorage:self.documentImageStorage
                                               copyImageStorage:YES
                                                       indexSet:nil
                                                   withPageSize:SBSDKPDFRendererPageSizeFromImage
                                                         output:pdfURL
                                              completionHandler:^(BOOL finished, NSError *error, NSDictionary *resultInfo)
    {
        if (finished && error == nil) {
            NSURL *outputURL = resultInfo[SBSDKResultInfoDestinationFileURLKey];
            DemoPDFViewController *pdfController = [DemoPDFViewController pdfControllerWithURL:outputURL];
            [self.navigationController pushViewController:pdfController animated:YES];
        } else {
            NSLog(@"%@", error);
        }
        self.currentProgress = nil;
        [self updateUI];
    }];
    
    [self updateUI];
}

- (IBAction)performOCR:(id)sender {
    if (self.currentProgress) {
        return;
    }
    
    if (self.documentImageStorage.imageCount == 0) {
        return;
    }
    
    self.currentProgress =
    [SBSDKOpticalTextRecognizer recognizeText:self.documentImageStorage
                             copyImageStorage:YES
                                     indexSet:nil
                               languageString:@"en+de"
                                 pdfOutputURL:nil
                                   completion:^(BOOL finished, NSError *error, NSDictionary *resultInfo)
     {
         if (error == nil && finished) {
             SBSDKOCRResult *result = resultInfo[SBSDKResultInfoOCRResultsKey];
             TextViewController *textController = [TextViewController textControllerWithText:result.recognizedText];
             [self.navigationController pushViewController:textController animated:YES];
         } else {
             NSLog(@"%@", error);
         }
         self.currentProgress = nil;
         [self updateUI];
     }];
    
    [self updateUI];
}

- (IBAction)createOCRPDF:(id)sender {
    if (self.currentProgress) {
        return;
    }
    
    if (self.documentImageStorage.imageCount == 0) {
        return;
    }
    
    NSString *filename = @"ScanbotSDK_PDF_OCR.pdf";
    NSURL *pdfURL = [SBSDKStorageLocation applicationDocumentsFolderURL];
    pdfURL = [pdfURL URLByAppendingPathComponent:filename];
    
    self.currentProgress =
    [SBSDKOpticalTextRecognizer recognizeText:self.documentImageStorage
                             copyImageStorage:YES
                                     indexSet:nil
                               languageString:@"en+de"
                                 pdfOutputURL:pdfURL
                                   completion:^(BOOL finished, NSError *error, NSDictionary *resultInfo)
     {
         if (error == nil && finished) {
             DemoPDFViewController *pdfController = [DemoPDFViewController pdfControllerWithURL:pdfURL];
             [self.navigationController pushViewController:pdfController animated:YES];
         }
         if (error) {
             NSLog(@"%@", error);
         }
         self.currentProgress = nil;
         [self updateUI];
     }];
    
    [self updateUI];
}

- (IBAction)performSingleImageOCR:(id)sender {
    if (self.currentProgress) {
        return;
    }
    
    if (self.documentImageStorage.imageCount == 0) {
        return;
    }
    
    // Please note: For the sake of simplicity, we use only the first taken image in this example app!
    NSURL *imageURL = [self.documentImageStorage imageURLAtIndex:0];
    
    self.currentProgress =
    [SBSDKOpticalTextRecognizer recognizeText:imageURL
                                    rectangle:CGRectMake(0, 0, 1, 1)
                               languageString:@"en+de"
                                   completion:^(BOOL finished, NSError *error, NSDictionary *resultInfo)
    {
        if (error == nil && finished) {
            SBSDKOCRResult *result = resultInfo[SBSDKResultInfoOCRResultsKey];
            TextViewController *textController = [TextViewController textControllerWithText:result.recognizedText];
            [self.navigationController pushViewController:textController animated:YES];
        } else {
            NSLog(@"%@", error);
        }
        self.currentProgress = nil;
        [self updateUI];
    }];
    [self updateUI];
}

- (IBAction)performPageAnalysis:(id)sender {
    if (self.currentProgress) {
        return;
    }
    
    if (self.documentImageStorage.imageCount == 0) {
        return;
    }
    
    // Please note: For the sake of simplicity, we use only the first taken image in this example app!
    NSURL *imageURL = [self.documentImageStorage imageURLAtIndex:0];
    
    self.currentProgress =
    [SBSDKOpticalTextRecognizer analyseImagePageLayout:imageURL
                                            completion:^(BOOL finished, NSError *error, NSDictionary *resultInfo)
    {
        if (error == nil && finished) {
            SBSDKPageAnalyzerResult *result = resultInfo[SBSDKResultInfoPageAnalyzerResultsKey];
            UIAlertController *resultsController
            = [UIAlertController alertControllerWithTitle:@"Page layout analysis"
                                                  message:result.description
                                           preferredStyle:UIAlertControllerStyleAlert];
            
            [resultsController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction *action)
            {
                [self dismissViewControllerAnimated:YES completion:nil];
            }]];
            
            [self presentViewController:resultsController animated:YES completion:nil];
        } else {
            NSLog(@"%@", error);
        }
        self.currentProgress = nil;
        [self updateUI];
     }];
    [self updateUI];
}

- (IBAction)performManualCrop:(id)sender {
    // Please note: For the sake of simplicity, we use only the first taken image in this example app!
    UIImage *image = [self.originalImageStorage imageAtIndex:0];
    SBSDKImageEditingViewController *editingViewController = [[SBSDKImageEditingViewController alloc] init];
    editingViewController.image = image;
    editingViewController.delegate = self;
    [self.navigationController pushViewController:editingViewController animated:YES];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - SBSDKImageEditingViewControllerDelegate implementation

- (void)imageEditingViewControllerDidCancelChanges:(SBSDKImageEditingViewController *)editingViewController {
    [editingViewController.navigationController popViewControllerAnimated:YES];
}

- (void)imageEditingViewController:(SBSDKImageEditingViewController *)editingViewController
        didApplyChangesWithPolygon:(SBSDKPolygon *)polygon croppedImage:(UIImage *)croppedImage {
    // Here we get the cropped image result as well as the applied polygon.
    // Perform custom actions with results..
    
    // Update the document image:
    // Please note: For the sake of simplicity, we use only the first taken image in this example app!
    [self.documentImageStorage removeImageAtIndex:0];
    [self.documentImageStorage insertImage:croppedImage atIndex:0];
    
    [editingViewController.navigationController popViewControllerAnimated:YES];
}

- (UIBarButtonItem *_Nullable)imageEditingViewControllerRotateClockwiseToolbarItem:(nonnull SBSDKImageEditingViewController *)editingViewController {
    return [[UIBarButtonItem alloc] initWithTitle:@"Rotate Right"
                                            style:UIBarButtonItemStylePlain
                                           target:nil action:NULL];
}

- (UIBarButtonItem *_Nullable)imageEditingViewControllerRotateCounterClockwiseToolbarItem:(nonnull SBSDKImageEditingViewController *)editingViewController {
    return [[UIBarButtonItem alloc] initWithTitle:@"Rotate Left"
                                            style:UIBarButtonItemStylePlain
                                           target:nil action:NULL];
}

- (UIBarButtonItem *)imageEditingViewControllerApplyButtonItem:(SBSDKImageEditingViewController *)editingViewController {
    return [[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                            style:UIBarButtonItemStylePlain
                                           target:nil action:NULL];
}

@end

