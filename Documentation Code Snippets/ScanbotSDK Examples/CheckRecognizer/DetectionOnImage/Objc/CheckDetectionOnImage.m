//
//  CheckDetectionOnImage.m
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 27.03.23.
//

#import "CheckDetectionOnImage.h"
@import ScanbotSDK;

@implementation CheckDetectionOnImage

- (void) detectCheckOnImage {
    
    // Image containing Check.
    UIImage *image = [UIImage imageNamed:@"checkImage"];
    
    // Creates an instance of `SBSDKCheckRecognizer`.
    SBSDKCheckRecognizer *detector = [[SBSDKCheckRecognizer alloc] init];
    
    // Type of checks that needs to be detected.
    NSArray<SBSDKCheckDocumentRootType *> *acceptedCheckTypes = [SBSDKCheckDocumentRootType allDocumentTypes];
    
    // Set the types of check on detector.
    [detector setAcceptedCheckTypes:acceptedCheckTypes];
    
    // Returns the result after running detector on the image.
    SBSDKCheckRecognizerResult *result = [detector recognizeOnImage:image];
}

@end
