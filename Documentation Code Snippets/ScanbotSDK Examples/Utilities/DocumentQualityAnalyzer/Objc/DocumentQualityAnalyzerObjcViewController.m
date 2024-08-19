//
//  DocumentQualityAnalyzerObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 14.11.23.
//

#import "DocumentQualityAnalyzerObjcViewController.h"
@import ScanbotSDK;

@interface DocumentQualityAnalyzerObjcViewController ()

@end

@implementation DocumentQualityAnalyzerObjcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize the analyzer.
    SBSDKDocumentQualityAnalyzer *analyzer = [[SBSDKDocumentQualityAnalyzer alloc] init];
    
    // Set the desired image.
    UIImage *image = [UIImage imageNamed:@"testDocument"];
    
    // Analyze the quality of the image.
    SBSDKDocumentQuality quality = [analyzer analyzeOnImage:image];
    
    // Handle the result.
    [self printResult:quality];
}

// Print the result.
- (void) printResult:(SBSDKDocumentQuality)quality {
    switch (quality) {
        case SBSDKDocumentQualityNoDocument:
            NSLog(@"No document was found");
            break;
        case SBSDKDocumentQualityVeryPoor:
            NSLog(@"The quality of the document is very poor");
            break;
        case SBSDKDocumentQualityPoor:
            NSLog(@"The quality of the document is quite poor");
            break;
        case SBSDKDocumentQualityReasonable:
            NSLog(@"The quality of the document is reasonable");
            break;
        case SBSDKDocumentQualityGood:
            NSLog(@"The quality of the document is good");
            break;
        case SBSDKDocumentQualityExcellent:
            NSLog(@"The quality of the document is excellent");
            break;
    }
}

@end
