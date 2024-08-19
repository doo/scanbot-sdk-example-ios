//
//  ImageProcessingObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 12.05.22.
//

#import "ImageProcessingObjcViewController.h"
@import ScanbotSDK;

@interface ImageProcessingObjcViewController ()

@end

@implementation ImageProcessingObjcViewController

- (void)asyncImageFilter {
    
    // Create an instance of an input image.
    UIImage *inputImage = [UIImage imageNamed:@"documentImage"];

    // Create an instance of `SBSDKImageProcessor` passing the input image to the initializer.
    SBSDKImageProcessor *processor = [[SBSDKImageProcessor alloc] initWithImage:inputImage];
    
    // Perform operations like rotating, resizing and applying filters to the image.
    // Rotate the image.
    [processor rotate:SBSDKImageRotationClockwise90];
    
    // Resize the image.
    [processor resize:700];
    
    // Create an instance of the filter you want to apply.
    SBSDKScanbotBinarizationFilter *filter = [[SBSDKScanbotBinarizationFilter alloc]
                                              initWithOutputMode:SBSDKOutputModeAntialiased];
    
    // Apply the filter.
    [processor applyFilter:filter];
    
    // Retrieve the processed image.
    UIImage *processedImage = processor.processedImage;
}

- (void)detectAndApplyPolygon {
    
    // Create an instance of an input image.
    UIImage *inputImage = [UIImage imageNamed:@"documentImage"];

    // Create a document detector.
    SBSDKDocumentDetector *detector = [[SBSDKDocumentDetector alloc] init];

    // Let the document detector run on the input image.
    SBSDKDocumentDetectorResult *result = [detector detectDocumentPolygonOnImage:inputImage
                                                                visibleImageRect:CGRectZero
                                                                smoothingEnabled:NO
                                                      useLiveDetectionParameters:NO];

    // Check the result and retrieve the detected polygon.
    if (result.status == SBSDKDocumentDetectionStatusOk && result.polygon != nil)  {
        
        // If the result is an acceptable polygon, we warp the image into the polygon.
        SBSDKImageProcessor *processor = [[SBSDKImageProcessor alloc] initWithImage:inputImage];
        
        // Crop the image using the polygon.
        [processor crop:result.polygon];
        
        // Retrieve the processed image.
        UIImage *processedImage = processor.processedImage;
        
    } else {
        
        // No acceptable polygon found.
    }
}

@end
