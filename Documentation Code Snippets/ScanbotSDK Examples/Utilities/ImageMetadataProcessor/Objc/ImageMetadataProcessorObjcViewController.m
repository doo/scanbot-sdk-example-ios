//
//  ImageMetadataProcessorObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 01.12.22.
//

#import "ImageMetadataProcessorObjcViewController.h"
@import ScanbotSDK;

@interface ImageMetadataProcessorObjcViewController ()

@end

@implementation ImageMetadataProcessorObjcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set the desired image.
    UIImage *image = [UIImage imageNamed:@"documentImage"];
    
    // Convert the image to data.
    NSData *imageData = UIImageJPEGRepresentation(image, 0);
    
    // Extract the metadata.
    SBSDKImageMetadata *oldExtractedMetadata = [SBSDKImageMetadataProcessor extractMetadataFromImageData:imageData];
    
    [self printExtractedMetadata:oldExtractedMetadata withTitle:@"OLD metadata"];
    
    // Create new metadata or modify the extracted metadata.
    SBSDKImageMetadata *injectedMetadata = [[SBSDKImageMetadata alloc] 
                                            initWithMetadataDictionary:oldExtractedMetadata.metadataDictionary];
    injectedMetadata.title = @"Scanbot SDK";
    injectedMetadata.originalDate = [[NSDate alloc] init];
    
    // Inject the new metadata to the image data.
    NSData *newImageData = [SBSDKImageMetadataProcessor imageDataByInjectingMetadata:injectedMetadata
                                                                       intoImageData:imageData];
    
    // Re-extract the new metadata.
    SBSDKImageMetadata *newExtractedMetadata = [SBSDKImageMetadataProcessor extractMetadataFromImageData:newImageData];
    
    [self printExtractedMetadata:newExtractedMetadata withTitle:@"NEW metadata"];
}

// Print some of the metadata fields.
- (void) printExtractedMetadata:(SBSDKImageMetadata*)metadata withTitle:(NSString*)title {
    NSLog(@"Begin of %@ *************", title);
    NSLog(@"altitude: %f", metadata.altitude);
    NSLog(@"latitude: %f", metadata.latitude);
    NSLog(@"longitude: %f", metadata.longitude);
    NSLog(@"aperture: %f", metadata.aperture);
    NSLog(@"digitalizationDate: %@",  [metadata.digitalizationDate description]);
    NSLog(@"exposureTime: %f", metadata.exposureTime);
    NSLog(@"focalLength: %f", metadata.focalLength);
    NSLog(@"focalLength35mm: %f", metadata.focalLength35mm);
    NSLog(@"imageHeight: %lu", (unsigned long)metadata.imageHeight);
    NSLog(@"imageWidth: %lu",  (unsigned long)metadata.imageWidth);
    NSLog(@"isoValue: %f", metadata.ISOValue);
    NSLog(@"lensMaker: %@", metadata.lensMaker);
    NSLog(@"lensModel: %@", metadata.lensModel);
    NSLog(@"orientation: %lu", (unsigned long)metadata.orientation);
    NSLog(@"originalDate: %@", [metadata.originalDate description]);
    NSLog(@"title: %@", metadata.title);
    NSLog(@"metadataDictionary: %@", metadata.metadataDictionary);
    NSLog(@"End of %@ *************", title);
} 
@end
