//
//  VinDetectionOnImage.m
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 04.08.23.
//

#import "VinDetectionOnImage.h"
@import ScanbotSDK;

@implementation VinDetectionOnImage

- (void) detectVinOnImage {
    
    // Image containing Vehicle Identification number.
    UIImage *image = [UIImage imageNamed:@"vinImage"];
    
    // Creates an instance of `SBSDKVehicleIdentificationNumberScannerConfiguration`.
    SBSDKVehicleIdentificationNumberScannerConfiguration *configuration = [SBSDKVehicleIdentificationNumberScannerConfiguration defaultConfiguration];
    
    // Creates an instance of `SBSDKVehicleIdentificationNumberScanner` using the configuration created above.
    SBSDKVehicleIdentificationNumberScanner *scanner = [[SBSDKVehicleIdentificationNumberScanner alloc] initWithConfiguration:configuration];
    
    // Returns the result after running detector on the image.
    SBSDKVehicleIdentificationNumberScannerResult *result = [scanner recognizeOnStillImage:image];
}

@end
