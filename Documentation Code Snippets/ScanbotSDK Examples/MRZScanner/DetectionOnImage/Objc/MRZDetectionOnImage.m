//
//  MRZDetectionOnImage.m
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 24.03.23.
//

#import "MRZDetectionOnImage.h"
@import ScanbotSDK;

@implementation MRZDetectionOnImage

- (void) detectMRZOnImage {
    
    // Image containing MRZ.
    UIImage *image = [UIImage imageNamed:@"mrzImage"];
    
    // Creates an instance of `SBSDKMachineReadableZoneRecognizer`.
    SBSDKMachineReadableZoneRecognizer *detector = [[SBSDKMachineReadableZoneRecognizer alloc] init];
    
    // Returns the result after running detector on the image.
    SBSDKMachineReadableZoneRecognizerResult *result = [detector recognizePersonalIdentityFromImage:image];
}

@end
