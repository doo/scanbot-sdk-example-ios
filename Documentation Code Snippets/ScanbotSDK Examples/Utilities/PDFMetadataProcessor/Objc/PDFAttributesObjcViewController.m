//
//  PDFAttributesObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 02.12.22.
//

#import "PDFAttributesObjcViewController.h"
@import ScanbotSDK;

@interface PDFAttributesObjcViewController ()

@end

@implementation PDFAttributesObjcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Get the URL of your desired pdf file.
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"document" withExtension:@"pdf"];
    
    // Read the pdf metadata attributes from the PDF at the url.
    SBSDKPDFAttributes *attributes = [[SBSDKPDFAttributes alloc] initWithPdfURL:url];
    
    // Edit the pdf metadata.
    attributes.title = @"A Scanbot Demo PDF";
    attributes.author = @"ScanbotSDK Development";
    attributes.creator = @"ScanbotSDK for iOS";
    attributes.subject = @"A demonstration of ScanbotSDK PDF creation.";
    attributes.keywords = @[@"PDF", @"Scanbot", @"SDK"];
    
    // Inject the new pdf metadata in your pdf at the same url or in a new created url.
    NSError *error = nil;
    [attributes saveToPDFFileAt:url error:&error];
    
    // Handle error.
    if (error) {
        NSLog(@"Error caught: %@", error.localizedDescription);
    } else {
        NSLog(@"Save successful");
    }
}

@end
