//
//  BarcodeDetectionOnImage.m
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 24.03.23.
//

#import "BarcodeDetectionOnImage.h"
@import ScanbotSDK;

@implementation BarcodeDetectionOnImage

- (void) detectBarcodesOnImage {
    
    // Image containing barcode.
    UIImage *image = [UIImage imageNamed:@"barcodeImage"];
    
    // Types of barcodes you want to detect.
    NSArray<SBSDKBarcodeType *> *typesToDetect = [SBSDKBarcodeType allTypes];
    
    // Creates an instance of `SBSDKBarcodeScanner`.
    SBSDKBarcodeScanner *detector = [[SBSDKBarcodeScanner alloc] initWithTypes:typesToDetect];
    
    // Returns the result after running detector on the image.
    NSArray<SBSDKBarcodeScannerResult *> *results = [detector detectBarCodesOnImage:image];
}

@end
