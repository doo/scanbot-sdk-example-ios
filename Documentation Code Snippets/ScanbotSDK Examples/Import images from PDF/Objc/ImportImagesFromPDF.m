//
//  ImportImagesFromPDF.m
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 24.03.23.
//

#import "ImportImagesFromPDF.h"
@import ScanbotSDK;

@implementation ImportImagesFromPDF

- (void)createImagesFromPDF {
    
    // The path where the pdf is stored.
    NSURL *pdfURL = [[NSURL alloc] initWithString:@"<path_to_pdf>"];
    
    // Creates an instance of `SBSDKPDFPagesExtractor`
    SBSDKPDFPagesExtractor *pageExtractor = [[SBSDKPDFPagesExtractor alloc] init];
    
    // Extracts pages from the pdf and returns an array of UIImages
    NSArray<UIImage *> *images = [pageExtractor imagesFromPDF:pdfURL];
    
    NSArray<UIImage *> *scaledImages = [pageExtractor imagesFromPDF:pdfURL scaling:2.0];
}

@end
