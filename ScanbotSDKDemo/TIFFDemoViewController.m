//
//  TIFFDemoViewController.m
//  ScanbotSDKDemo
//
//  Created by Andrew Petrus on 08.02.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import "TIFFDemoViewController.h"

@import ScanbotSDK;

@interface TIFFDemoViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) NSMutableArray<UIImage *> *images;
@property (weak, nonatomic) IBOutlet UILabel *imagesCountLabel;

@end

@implementation TIFFDemoViewController

- (NSString *)applicationDocumentsDirectory{
    return [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] path];
}

- (void)showResult:(BOOL)success filePath:(NSString *)filePath {
    UIAlertController *alert = nil;
    if (success) {
        alert = [UIAlertController alertControllerWithTitle:@"File saved"
                                                    message:[NSString stringWithFormat:@"TIFF file saved at path: %@", filePath]
                                             preferredStyle:UIAlertControllerStyleAlert];
    } else {
        alert = [UIAlertController alertControllerWithTitle:@"File not saved"
                                                    message:@"There was an error while saving TIFF file"
                                             preferredStyle:UIAlertControllerStyleAlert];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)checkHasImages {
    if (self.images.count > 0) {
        return YES;
    }

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Image(s) required"
                                                                   message:@"Please add at least one image from the Photo Library."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    return NO;
}


- (IBAction)addImageButtoTapped:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)generateTIFFTapped:(id)sender {
    if (!self.checkHasImages) {
        return;
    }
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.tiff",
                          [self applicationDocumentsDirectory], [[[NSUUID UUID] UUIDString] lowercaseString]];
    NSURL *fileURL = [NSURL URLWithString:filePath];
    
    SBSDKTIFFImageWriterParameters *params = [SBSDKTIFFImageWriterParameters defaultParameters];
    params.compression = COMPRESSION_LZW;
    params.dpi = 200;
    
    BOOL result = [SBSDKTIFFImageWriter writeTIFF:self.images fileURL:fileURL parameters:params];

    [self showResult:result filePath:filePath];
}

- (IBAction)generateBinarizedTIFFTapped:(id)sender {
    if (!self.checkHasImages) {
        return;
    }

    NSString *filePath = [NSString stringWithFormat:@"%@/%@_binarized.tiff",
                          [self applicationDocumentsDirectory], [[[NSUUID UUID] UUIDString] lowercaseString]];
    NSURL *fileURL = [NSURL URLWithString:filePath];
    
    SBSDKTIFFImageWriterParameters *params = [SBSDKTIFFImageWriterParameters defaultParameters];
    // alternatively init params via defaultParametersForBinaryImages, like:
    // SBSDKTIFFImageWriterParameters *params = [SBSDKTIFFImageWriterParameters defaultParametersForBinaryImages];
    params.binarize = YES;
    params.compression = COMPRESSION_CCITT_T6;
    params.dpi = 200;

    BOOL result = [SBSDKTIFFImageWriter writeTIFF:self.images fileURL:fileURL parameters:params];
    
    [self showResult:result filePath:filePath];
}

#pragma mark - UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (!self.images) {
        self.images = [NSMutableArray array];
    }
    
    [self.images addObject:image];
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 self.imagesCountLabel.text = [NSString stringWithFormat:@"Images added: %lu", (unsigned long)self.images.count];
                             }];

}

@end
