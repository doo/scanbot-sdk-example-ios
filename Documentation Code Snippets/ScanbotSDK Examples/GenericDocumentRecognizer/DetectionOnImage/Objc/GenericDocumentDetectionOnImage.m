//
//  GenericDocumentDetectionOnImage.m
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 27.03.23.
//

#import "GenericDocumentDetectionOnImage.h"
@import ScanbotSDK;

@implementation GenericDocumentDetectionOnImage

- (void) detectGenericDocumentOnImage {
    
    // Image containing generic document.
    UIImage *image = [UIImage imageNamed:@"genericDocumentImage"];
    
    // Types of generic documents you want to detect.
    NSArray<SBSDKGenericDocumentRootType *> *typesToDetect = [SBSDKGenericDocumentRootType allDocumentTypes];
    
    // Creates an instance of `SBSDKGenericDocumentRecognizer`.
    SBSDKGenericDocumentRecognizer *detector = [[SBSDKGenericDocumentRecognizer alloc] initWithAcceptedDocumentTypes:typesToDetect];
    
    // Returns the result after running detector on the image.
    SBSDKGenericDocumentRecognitionResult *result = [detector recognizeDocumentOnImage:image];
}

@end
