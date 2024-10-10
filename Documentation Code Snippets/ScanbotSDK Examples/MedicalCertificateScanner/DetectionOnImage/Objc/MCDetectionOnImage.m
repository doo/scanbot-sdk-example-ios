//
//  MCDetectionOnImage.m
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 27.03.23.
//

#import "MCDetectionOnImage.h"
@import ScanbotSDK;

@implementation MCDetectionOnImage

- (void) detectMedicalCertificateOnImage {
    
    // Image containing Medical Certificate.
    UIImage *image = [UIImage imageNamed:@"medicalCertificateImage"];
    
    // Creates an instance of `SBSDKMedicalCertificateRecognizer`.
    SBSDKMedicalCertificateRecognizer *detector = [[SBSDKMedicalCertificateRecognizer alloc] init];
    
    // Returns the result after running detector on the image.
    SBSDKMedicalCertificateRecognizerResult *result = [detector recognizeFromImage:image detectDocument:TRUE];
}

@end
