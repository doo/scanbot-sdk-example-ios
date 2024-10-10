//
//  TIFFCreation.m
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 26.10.21.
//

#import "TIFFCreation.h"
@import ScanbotSDK;

@implementation TIFFCreation

- (void)createTIFF {
    
    // For this example we're using an empty array, but there should be scanned images in it.
    NSArray<UIImage *> *scannedImages = @[];

    // Specify the file URL where the TIFF will be saved to. Nil makes no sense here.
    NSURL *outputURL = [[NSURL alloc] initWithString:@"outputTIFF"];

    // In case you want to encrypt your TIFF file, create encrypter using a password and an encryption mode.
    SBSDKAESEncrypter *encrypter = [[SBSDKAESEncrypter alloc] initWithPassword:@"password_example#42"
                                                                          mode:SBSDKAESEncrypterModeAES256];

    // The `SBSDKTIFFImageWriter` has parameters where you can define various options,
    // e.g. compression algorithm or whether the document should be binarized.
    // For this example we're going to use the default parameters.
    SBSDKTIFFImageWriterParameters *parameters = [SBSDKTIFFImageWriterParameters defaultParameters];
    
    // Create the tiff image writer using created parameters and the encrypter.
    SBSDKTIFFImageWriter *tiffImageWriter = [[SBSDKTIFFImageWriter alloc] initWithParameters:parameters
                                                                                   encrypter:encrypter];

    // Write a TIFF file with scanned images into the defined URL.
    // The completion handler passes a file URL where the file was to be saved, or nil if the operation did not succeed.
    [tiffImageWriter writeTIFFWith:scannedImages toFile:outputURL completion:^(NSURL * _Nullable url) {
        
        // Handle the URL.
    }];
}

@end
