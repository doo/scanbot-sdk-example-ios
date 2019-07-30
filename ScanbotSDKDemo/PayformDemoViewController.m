//
//  PayformDemoViewController.m
//  ScanbotSDKDemo
//
//  Created by Sebastian Husche on 17.02.16.
//  Copyright © 2016 doo GmbH. All rights reserved.
//

#import "PayformDemoViewController.h"
#import "ScanbotSDKInclude.h"

@interface PayformDemoViewController () <SBSDKCameraSessionDelegate>

@property(nonatomic, strong) SBSDKCameraSession *cameraSession;
@property(nonatomic, strong) SBSDKPayFormScanner *payformScanner;
@property(atomic, assign) BOOL detectionEnabled;
@end

@implementation PayformDemoViewController

- (void)initializeCameraSession {
    self.cameraSession = [[SBSDKCameraSession alloc] initForFeature:FeaturePayformDetection];
    self.cameraSession.videoDelegate = self;
    [self.view.layer addSublayer:self.cameraSession.previewLayer];
}

- (void)initializePayformScanner {
    self.payformScanner = [[SBSDKPayFormScanner alloc] init];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self initializeCameraSession];
    [self initializePayformScanner];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.cameraSession.previewLayer.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.cameraSession startSession];
    self.detectionEnabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.detectionEnabled = NO;
}

- (NSString *)stringFromField:(SBSDKPayFormRecognizedField *)field {
    NSString *tokenName = @"Unknown token";
    switch (field.token.type) {
        case SBSDKPayFormTokenTypeReceiver:
            tokenName = @"Receiver";
            break;
            
        case SBSDKPayFormTokenTypeIBAN:
            tokenName = @"IBAN";
            break;
            
        case SBSDKPayFormTokenTypeBIC:
            tokenName = @"BIC";
            break;
            
        case SBSDKPayFormTokenTypeAmount:
            tokenName = @"Amount";
            break;
            
        case SBSDKPayFormTokenTypeReferenceNumber:
            tokenName = @"Reference number";
            break;

        case SBSDKPayFormTokenTypeReferenceNumber2:
            tokenName = @"Reference number 2";
            break;
            
        case SBSDKPayFormTokenTypeSender:
            tokenName = @"Sender";
            break;

        case SBSDKPayFormTokenTypeSenderIBAN:
            tokenName = @"Sender IBAN";
            break;

        default:
            break;
    }
    
    return [tokenName stringByAppendingFormat:@": %@", field.value.length > 0 ? field.value : @"-"];
}

- (NSString *)stringFromResult:(SBSDKPayFormRecognitionResult *)result {
    NSMutableArray *fields = [NSMutableArray arrayWithCapacity:result.recognizedFields.count];
    for (SBSDKPayFormRecognizedField *field in result.recognizedFields) {
        NSString *fieldString = [self stringFromField:field];
        [fields addObject:fieldString];
    }
    return [fields componentsJoinedByString:@"\n"];
}

- (void)presentResult:(SBSDKPayFormRecognitionResult *)result {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Payform detected"
                                                                   message:[self stringFromResult:result]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         self.detectionEnabled = YES;
    }];
    
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {
    
    if (!self.detectionEnabled) {
        return;
    }
    AVCaptureVideoOrientation orientation = self.cameraSession.videoOrientation;
    
    SBSDKPayFormRecognitionResult *recognitionResult = [self.payformScanner recognizeFromSampleBuffer:sampleBuffer orientation:orientation];
    if (recognitionResult.recognitionSuccessful) {
        self.detectionEnabled = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentResult:recognitionResult];
        });
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    AVCaptureVideoOrientation videoOrientation = AVCaptureVideoOrientationPortrait;
    switch (orientation) {
        
        case UIInterfaceOrientationPortrait:
            videoOrientation = AVCaptureVideoOrientationPortrait;
            break;
        
        case UIInterfaceOrientationPortraitUpsideDown:
            videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        
        case UIInterfaceOrientationLandscapeLeft:
            videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
        
        case UIInterfaceOrientationLandscapeRight:
            videoOrientation = AVCaptureVideoOrientationLandscapeRight;
        
        default:
            break;
    }
    self.cameraSession.videoOrientation = videoOrientation;
}

/** Uncomment the following 2 methods if you want to suppress automatic interface rotations. **/
//- (BOOL)shouldAutorotate {
//    return NO;
//}
//
//- (NSUInteger)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskPortrait;
//}

@end
