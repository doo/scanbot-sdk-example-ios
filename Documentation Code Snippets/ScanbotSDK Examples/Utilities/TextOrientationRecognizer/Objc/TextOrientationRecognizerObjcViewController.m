//
//  TextOrientationRecognizerObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 02.12.22.
//

#import "TextOrientationRecognizerObjcViewController.h"
@import ScanbotSDK;

@interface TextOrientationRecognizerObjcViewController ()

@end

@implementation TextOrientationRecognizerObjcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // We initialize an instance of our recognizer.
    SBSDKTextLayoutRecognizer *recognizer = [[SBSDKTextLayoutRecognizer alloc] init];
    
    // Set the desired image.
    UIImage *image = [UIImage imageNamed:@"testDocument"];
    
    if (image != nil) {
        
        // Recognize the text orientation.
        SBSDKTextOrientation oldOrientation = [recognizer recognizeTextOrientationOnImage:image];
        
        // Handle the result.
        [self printOrientationResultForOrientation:oldOrientation];
        
        // Recognize the text orientation, but request a minimum confidence of 2.0.
        SBSDKTextOrientation orientationWithConfidence = [recognizer recognizeTextOrientationOnImage:image 
                                                                                      withConfidence:2.0f];
        
        // Handle the result.
        [self printOrientationResultForOrientation:oldOrientation];
        
        // Rotate the image to portrait mode if possible.
        UIImage *newImage = [self rotateImageToPortraitModeWithImage:image withOrientation:orientationWithConfidence];
        
    }    
}

// Rotate the image according to the recognized orientation.
- (UIImage*) rotateImageToPortraitModeWithImage:(UIImage*)image withOrientation:(SBSDKTextOrientation)orientation {
    switch (orientation) {
        case SBSDKTextOrientationNotRecognized:
        case SBSDKTextOrientationLowConfidence:
        case SBSDKTextOrientationUp:
            return image;
            break;
        case SBSDKTextOrientationRight:
            return [image sbsdk_imageRotatedCounterClockwise:1];
            break;
        case SBSDKTextOrientationDown:
            return [image sbsdk_imageRotatedClockwise:2];
            break;
        case SBSDKTextOrientationLeft:
            return [image sbsdk_imageRotatedCounterClockwise:3];
            break;
        default:
            return image;
            break;
    }
}

// Print the recognized orientation to the console.
- (void)printOrientationResultForOrientation:(SBSDKTextOrientation)orientation {
    switch (orientation) {
        case SBSDKTextOrientationNotRecognized:
            NSLog(@"Text orientation was not recognized (bad image quality, etc).");
            break;
        case SBSDKTextOrientationLowConfidence:
            NSLog(@"Text were recognized, but the confidence of recognition is too low.");
            break;
        case SBSDKTextOrientationUp:
            NSLog(@"Text is not rotated.");
            break;
        case SBSDKTextOrientationRight:
            NSLog(@"Text is rotated 90 degrees clockwise.");
            break;
        case SBSDKTextOrientationDown:
            NSLog(@"Text is rotated 180 degrees clockwise.");
            break;
        case SBSDKTextOrientationLeft:
            NSLog(@"Text is rotated 270 degrees clockwise.");
            break;
        default:
            break;
    }
}
@end
