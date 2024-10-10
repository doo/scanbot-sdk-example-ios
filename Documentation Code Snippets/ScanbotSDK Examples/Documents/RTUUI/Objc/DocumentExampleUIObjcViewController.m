//
//  DocumentExampleUIObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Danil Voitenko on 10.09.21.
//

#import "DocumentExampleUIObjcViewController.h"
@import ScanbotSDK;

@interface DocumentExampleUIObjcViewController ()

@end

@implementation DocumentExampleUIObjcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // For this example we're going to create a mock scanned document image.
    UIImage *documentImage = [UIImage imageNamed:@"documentImage"];

    // Create a page with a UIImage instance.
    SBSDKDocumentPage *page = [[SBSDKDocumentPage alloc] initWithImage:documentImage
                                                               polygon:nil
                                                                filter:SBSDKImageFilterTypeNone];

    // Return the result of the detected document on an image.
    SBSDKDocumentDetectorResult *result = [page detectDocumentAndApplyPolygonIfOkay:TRUE];

    // Rotate the image 180 degrees clockwise. Negative values will rotate the image counter-clockwise.
    [page rotateClockwise:2];

    // Return the detected document preview image.
    UIImage *previewImage = [page documentPreviewImage];

    // Return the url of the original image.
    NSURL *originalImageURL = [page originalImageURL];

    // Create an empty document instance.
    SBSDKDocument *document = [[SBSDKDocument alloc] init];

    // Add the page to the document.
    [document addPage:page];

    // Replace the first page of the document with the new page.
    [document replacePageAtIndex:0 withPage:page];

    // Remove the first page from the document.
    [document removePageAtIndex:0];

    // Find the index of the page by its identifier.
    NSInteger index = [document indexOfPageWithPageFileID:page.pageFileUUID];
}

@end
