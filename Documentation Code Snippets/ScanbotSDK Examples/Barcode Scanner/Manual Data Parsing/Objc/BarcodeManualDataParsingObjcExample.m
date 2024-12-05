//
//  BarcodeManualDataParsingObjcExample.m
//  ScanbotSDK Examples
//
//  Created by Rana Sohaib on 05.12.24.
//

#import "BarcodeScannerObjcViewController.h"
@import ScanbotSDK;

@interface BarcodeManualDataParsingObjcExample : NSObject

- (void)parseDataManually;

@end

@implementation BarcodeManualDataParsingObjcExample

- (void)parseDataManually {
    
    // Some raw barcode string.
    NSString *rawBarcodeString = @"(01)02804086001986(3103)000220(15)220724(30)01(3922)00198";

    // Instantiate the parser.
    SBSDKBarcodeDocumentParser *parser = [[SBSDKBarcodeDocumentParser alloc] init];

    // Run the parser and check the result.
    SBSDKGenericDocument *document = [parser parseDocumentWithInputString:rawBarcodeString];
    
    if (document) {
        
        // Parse the resulted document as a GS1 document.
        SBSDKBarcodeDocumentGS1 *gs1ParsedDocument = [[SBSDKBarcodeDocumentGS1 alloc] initWithGenericDocument:document];
        
        // Retrieve the elements.
        NSArray<SBSDKBarcodeDocumentGS1Element *> *elements = gs1ParsedDocument.elements;

        if (elements) {
            
            // Enumerate over the elements.
            for (SBSDKBarcodeDocumentGS1Element *element in elements) {
                // Do something with the element.
                NSString *dataTitle = element.dataTitle.value.text ?: @"";
                NSString *rawValue = element.rawValue.value.text ?: @"";
                NSLog(@"%@ = %@", dataTitle, rawValue);
            }
        }
    }
}

@end

