//
//  ImageStoringObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 06.12.22.
//

#import "ImageStoringObjcViewController.h"
@import ScanbotSDK;

@interface ImageStoringObjcViewController ()

@end

@implementation ImageStoringObjcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize a folder URL to persist the images to. 
    NSURL *documentsURL = [[SBSDKStorageLocation applicationDocumentsFolderURL] URLByAppendingPathComponent:@"Images"];
    
    // Create a storage location object. This will create the folder on the filesystem if neccessary.
    SBSDKStorageLocation *documentsLocation = [[SBSDKStorageLocation alloc] initWithBaseURL:documentsURL];
    
    // Initialize an indexed image storage at this location.
    // The indexed image storage is an array-like storage.
    SBSDKIndexedImageStorage *imageStorage 
    = [[SBSDKIndexedImageStorage alloc] initWithStorageLocation:documentsLocation
                                                     fileFormat:SBSDKImageFileFormatPNG
                                                      encrypter:nil];
    
    UIImage *image = [UIImage imageNamed:@"testDocument"];
    
    // Save an image to our location.
    BOOL isAdded = [imageStorage addImage:image];
    
    // Check the result.
    NSLog(@"Image added successfully : %@", isAdded ? @"YES" : @"NO");
    
    // Check the number of images in the storage.
    NSLog(@"Image Count: %lu", (unsigned long)[imageStorage imageCount]);
    
    // Create and attach an encrypter to the storage. This will encrypt the image data, before it it written to disk 
    // and decrypt it after it is read from disk. 
    // Setting the encrypter does not encrypt existing images in the storage, only the images that are added to the 
    // storage after setting the encrypter. 
    imageStorage.encrypter = [[SBSDKAESEncrypter alloc] initWithPassword:@"xxxxx" mode:SBSDKAESEncrypterModeAES256];
    
    // Store an image from a URL. This does not load the image and has a very low memory footprint.
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"imageDocument" withExtension:@"png"];

    // Copy the image from the URL to the storage.
    BOOL isAddedFromURL = [imageStorage addImageFromURL:url];
    
    // Check the result.
    NSLog(@"Image from URL was added successfully : %@", isAddedFromURL ? @"YES" : @"NO");
    
    // Make sure that the indices are valid before moving an image from index to another.
    if (imageStorage.imageCount > 1) {
        // Move the image at index 1 to index 0.
        BOOL isMoved = [imageStorage moveImageFromIndex:1 toIndex:0];
        NSLog(@"Image was moved successfully : %@", isMoved ? @"YES" : @"NO");
    }

    // Make sure that the index is valid.
    if (imageStorage.imageCount > 1) {
        // Remove the image at index 1.
        [imageStorage removeImageAtIndex:1];
    }
    
    // The image storage is persisted on disk. 
    // When the images are no longer needed they should be removed to free the disk space. 
    // Remove all images from the storage.
    [imageStorage removeAllImages];
}
@end
