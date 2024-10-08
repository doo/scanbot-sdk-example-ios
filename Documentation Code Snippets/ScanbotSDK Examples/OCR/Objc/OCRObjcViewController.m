//
//  OCRObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 12.05.22.
//

#import "OCRObjcViewController.h"
@import ScanbotSDK;

@interface OCRObjcViewController ()

@end

@implementation OCRObjcViewController

- (void)textLayoutRecognition {
    // The file URL of the image we want to analyze.
    NSURL *imageURL = [NSURL URLWithString:@"..."];

    // Start the text layout recognition by creating an instance of the recognizer and calling 
    // the recognizeLayout... function on it.
    SBSDKTextLayoutRecognizer *recognizer = [[SBSDKTextLayoutRecognizer alloc] init];
    [recognizer recognizeLayoutOnImageURL:imageURL completion:^(SBSDKTextLayoutRecognizerResult *result, NSError *error) {

        // In the completion handler check for the error and the result.
        if (error == nil && result != nil) {

            // Now we can work with the result.
            if (result.orientation == SBSDKTextOrientationUp && result.writingDirection == SBSDKWritingDirectionLeftToRight) {
                
            }
        }
    }];
    
    // Or if you need the text orientation only...
    SBSDKTextOrientation orientation = [recognizer recognizeTextOrientationOnImageURL:imageURL];
    // Now we can work with the result.
    if (orientation == SBSDKTextOrientationUp) {
        // Now we can work with the result.
    }
}

- (void)performTextRecognition {
    // The file URL of the image we want to analyze.
    NSURL *imageURL = [NSURL URLWithString:@"..."];

    // Create the OCR configuration object, either with the new ML engine...
    SBSDKOpticalCharacterRecognizerConfiguration *configuration_ML 
    = [SBSDKOpticalCharacterRecognizerConfiguration scanbotOCR];

    // ...or with the legacy engine
    SBSDKOpticalCharacterRecognizerConfiguration *configuration_Legacy 
    = [SBSDKOpticalCharacterRecognizerConfiguration tesseractWithLanguageString:@"en+de"];

    // Pass the configuration object to the initializer of the optical character recognizer.
    SBSDKOpticalCharacterRecognizer *recognizer 
    = [[SBSDKOpticalCharacterRecognizer alloc] initWithConfiguration:configuration_ML /* or configuration_Legacy */];

    // Run the recognizeOn... method of the recognizer.
    [recognizer recognizeOnImageURL:imageURL completion:^(SBSDKOCRResult *result, NSError *error) {
        
        // In the completion handler check for the error and result.
        if (result != nil && error == nil) {

            // At the end enumerate all words and log them to the console together with their confidence values and bounding boxes.
            for (SBSDKOCRPage *page in result.pages) {
                for (SBSDKOCRResultBlock *word in page.words) {
                    NSLog(@"Word: %@, Confidence: %0.0f, Polygon: %@",
                          word.text,
                          word.confidenceValue,
                          word.polygon.description);
                }
            }
        }
    }];
}

- (void)createPDF {
    // Create an image storage to save the captured document images to
    NSURL *imagesURL = [[SBSDKStorageLocation applicationDocumentsFolderURL]
                           URLByAppendingPathComponent:@"Images"];
    SBSDKStorageLocation *imagesLocation = [[SBSDKStorageLocation alloc] initWithBaseURL:imagesURL];
    SBSDKIndexedImageStorage *imageStorage = [[SBSDKIndexedImageStorage alloc] initWithStorageLocation:imagesLocation];

    // Specify the file URL where the PDF will be saved to. Nil makes no sense here.
    NSURL *outputPDFURL = [NSURL URLWithString:@"outputPDF"];

    // Create the OCR configuration for a searchable PDF (HOCR).
    SBSDKOpticalCharacterRecognizerConfiguration *ocrConfiguration 
    = [SBSDKOpticalCharacterRecognizerConfiguration scanbotOCR];
    
    // Create the default PDF rendering options.
    SBSDKPDFRendererOptions *options = [[SBSDKPDFRendererOptions alloc] init];
    
    // Set the OCR Configuration.
    options.ocrConfiguration = ocrConfiguration;
    
    // Create the PDF renderer and pass the pdf rendering options.
    SBSDKPDFRenderer *renderer = [[SBSDKPDFRenderer alloc] initWithOptions:options encrypter:nil];

    // Start the rendering operation and store the SBSDKProgress to watch the progress or cancel the operation.
    SBSDKProgress *progress = [renderer renderImageStorage:imageStorage 
                                                  indexSet:nil
                                                    output:outputPDFURL 
                                                completion:^(BOOL finished, NSError *error) {
        
        if (finished && error == nil) {
            // Now you can access the pdf file at outputPDFURL.
        }
    }];
}


@end
