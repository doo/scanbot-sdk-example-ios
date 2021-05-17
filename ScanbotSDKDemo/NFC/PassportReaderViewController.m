//
//  PassportReaderViewController.m
//
//  Created by Sebastian Husche on 30.04.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

#import "PassportReaderViewController.h"
#import "PassportReaderResultsViewController.h"
@import ScanbotSDK;

@interface PassportReaderViewController () <SBSDKPassportReaderDelegate, SBSDKUIMRZScannerViewControllerDelegate>

@property(nonatomic, strong) SBSDKNFCPassportReader *nfcReader;
@property(nonatomic, copy) NSString *passportNumber;
@property(nonatomic, copy) NSDate *birthDate;
@property(nonatomic, copy) NSDate *expirationDate;
@property(nonatomic, strong) SBSDKUIMRZScannerViewController *mrzController;
@property(nonatomic, strong) NSArray<SBSDKNFCDatagroup*>* currentResults;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;


@end

@implementation PassportReaderViewController

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.modalPresentationStyle = UIModalPresentationFullScreen;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.mrzController.recognitionEnabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    SBSDKUIMRZScannerConfiguration *configuration = SBSDKUIMRZScannerConfiguration.defaultConfiguration;
    configuration.uiConfiguration.finderAspectRatio = [[SBSDKAspectRatio alloc]initWithWidth:1.0 andHeight:0.18];
    configuration.uiConfiguration.cancelButtonHidden = YES;
    configuration.textConfiguration.finderTextHint = @"Please align the passports machine readable zone with the frame above to scan it.";
    
    self.mrzController = [SBSDKUIMRZScannerViewController createNewWithConfiguration:configuration andDelegate:self];
    
    [self sbsdk_attachViewController:self.mrzController inView:self.view];
    
    [self.view bringSubviewToFront:self.progressView];
}

- (void)startNFCScanning {
    if (@available(iOS 13, *)) {
        
        self.mrzController.recognitionEnabled = NO;
        self.nfcReader = [[SBSDKNFCPassportReader alloc] initWithPassportNumber:self.passportNumber
                                                                      birthDate:self.birthDate
                                                                 expirationDate:self.expirationDate
                                                                 initialMessage:@"Hold your phone over the passport."
                                                                       delegate:self];
        [self.nfcReader setMessage:@"Authenticating with passport..."];
    }
}

- (void)showResultsIfNeeded {
    if (self.currentResults.count == 0) {
        self.mrzController.recognitionEnabled = YES;
        return;
    }
    PassportReaderResultsViewController *controller = [PassportReaderResultsViewController makeWith:self.currentResults];
    [self.navigationController pushViewController:controller animated:YES];
    self.currentResults = nil;
}

- (void)passportReaderDidConnect:(nonnull SBSDKNFCPassportReader *)reader {
    [self.nfcReader setMessage:@"Enumerating available data groups..."];
    [reader enumerateDatagroups:^(NSArray<SBSDKNFCDatagroupType *>* types) {
        [self.nfcReader setMessage:@"Downloading data groups..."];
        [reader downloadDatagroupsOfType:types completion:^(NSArray<SBSDKNFCDatagroup *>* groups) {
            [self.nfcReader setMessage:@"Finished downloading data groups."];
            if (groups.count > 0) {
                self.currentResults = groups;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showResultsIfNeeded];
                });
            }
        }];
    }];
}

- (void)passportReader:(SBSDKNFCPassportReader *)reader didStartReadingGroup:(SBSDKNFCDatagroupType *)type {
    [self.nfcReader setMessage:[NSString stringWithFormat:@"Downloading data group %@...", type]];
    self.progressView.progress = 0.0f;
    self.progressView.hidden = NO;
}

- (void)passportReader:(SBSDKNFCPassportReader *)reader didProgressReadingGroup:(float)progress {
    self.progressView.progress = progress;
    self.progressView.hidden = NO;
}

- (void)passportReader:(SBSDKNFCPassportReader *)reader didFinishReadingGroup:(SBSDKNFCDatagroupType *)type {
    [self.nfcReader setMessage:[NSString stringWithFormat:@"Finished downloading data group %@...", type]];
    self.progressView.progress = 1.0f;
    self.progressView.hidden = YES;
}

- (void)passportReaderDidFinishSession:(SBSDKNFCPassportReader *)reader {
    self.progressView.hidden = YES;
    self.mrzController.recognitionEnabled = YES;
}

- (void)passportReaderDidCancelSession:(SBSDKNFCPassportReader *)reader {
    self.progressView.hidden = YES;
    self.mrzController.recognitionEnabled = YES;
}

- (void)mrzDetectionViewController:(nonnull SBSDKUIMRZScannerViewController *)viewController didDetect:(nonnull SBSDKMachineReadableZoneRecognizerResult *)zone {
    
    if (!self.mrzController.recognitionEnabled) {
        return;
    }
    
    if (zone.documentType != SBSDKMachineReadableZoneRecognizerResultDocumentTypePassport
        || !zone.recognitionSuccessful) {
        
        return;
    }
    
    self.passportNumber = zone.documentCodeField.value;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    df.dateFormat = @"dd.MM.yy";
    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    self.birthDate = [df dateFromString:zone.dateOfBirthField.value];
    self.expirationDate = [df dateFromString:zone.dateOfExpiryField.value];
    [self startNFCScanning];
}

@end
