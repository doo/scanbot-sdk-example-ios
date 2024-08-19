//
//  PDFCreation.m
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 26.10.21.
//

#import "PDFCreation.h"
@import ScanbotSDK;

@implementation PDFCreation

- (void)createPDF {
    // Create an image storage to save the captured document images to
    NSURL *imagesURL = [[SBSDKStorageLocation applicationDocumentsFolderURL]
                           URLByAppendingPathComponent:@"Images"];
    SBSDKStorageLocation *imagesLocation = [[SBSDKStorageLocation alloc] initWithBaseURL:imagesURL];
    SBSDKIndexedImageStorage *imageStorage = [[SBSDKIndexedImageStorage alloc] initWithStorageLocation:imagesLocation];

    // Define the indices of the images in the image storage you want to render into a PDF, e.g. the first 3.
    // To include all images you can simply pass nil for the indexSet. The indexSet is validated internally.
    // You don't need to concern yourself with the validity of all the indices.
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)];

    // Specify the file URL where the PDF will be saved to. Nil makes no sense here.
    NSURL *outputPDFURL = [NSURL URLWithString:@"outputPDF"];

    // In case you want to encrypt your PDF file, create encrypter using a password and an encryption mode.
    SBSDKAESEncrypter *encrypter = [[SBSDKAESEncrypter alloc] initWithPassword:@"password_example#42"
                                                                          mode:SBSDKAESEncrypterModeAES256];

    // Create the OCR configuration for a searchable PDF (HOCR).
    SBSDKOpticalCharacterRecognizerConfiguration *ocrConfiguration 
    = [SBSDKOpticalCharacterRecognizerConfiguration scanbotOCR];
    
    // Create the default PDF rendering options.
    SBSDKPDFRendererOptions *options = [[SBSDKPDFRendererOptions alloc] init];
    
    // Set the OCR Configuration.
    options.ocrConfiguration = ocrConfiguration; // Comment this line to not generate HOCR
    
    // Create the PDF renderer and pass the pdf rendering options.
    SBSDKPDFRenderer *renderer = [[SBSDKPDFRenderer alloc] initWithOptions:options];
    
    
    // Start the rendering operation and store the SBSDKProgress to watch the progress or cancel the operation.
    SBSDKProgress *progress = [renderer renderImageStorage:imageStorage 
                                                  indexSet:indexSet 
                                                 encrypter:encrypter 
                                                    output:outputPDFURL 
                                                completion:^(BOOL finished, NSError *error) {
        
        if (finished && error == nil) {
            // Now you can access the pdf file at outputPDFURL.
        }
    }];
}

@end
