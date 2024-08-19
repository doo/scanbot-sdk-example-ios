//
//  EhicDetectionOnImage.m
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 27.03.23.
//

#import "EhicDetectionOnImage.h"
@import ScanbotSDK;

@implementation EhicDetectionOnImage

- (void) detectEhicOnImage {
    
    // Image containing EU Health Insurance Card.
    UIImage *image = [UIImage imageNamed:@"ehicImage"];
    
    // Creates an instance of `SBSDKHealthInsuranceCardRecognizer`.
    SBSDKHealthInsuranceCardRecognizer *detector = [[SBSDKHealthInsuranceCardRecognizer alloc] init];
    
    // Returns the result after running detector on the image.
    SBSDKHealthInsuranceCardRecognitionResult *result = [detector recognizeOnStillImage:image];
}

@end
