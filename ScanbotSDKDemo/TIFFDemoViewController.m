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

- (IBAction)addImageButtoTapped:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)generateTIFFTapped:(id)sender {
    if (self.images.count == 0) {
        return;
    }
    
    NSString *filePath = [NSString stringWithFormat:@"%@/demo.tiff", [self applicationDocumentsDirectory]];
    NSURL *fileURL = [NSURL URLWithString:filePath];
    BOOL result = NO;
    if (self.images.count == 1) {
        result = [SBSDKTIFFImageWriter writeTIFF:self.images[0] fileURL:fileURL];
    } else {
        result = [SBSDKTIFFImageWriter writeMultiPageTIFF:self.images fileURL:fileURL];
    }
    [self showResult:result filePath:filePath];
}

- (IBAction)generateBinarizedTIFFTapped:(id)sender {
    if (self.images.count == 0) {
        return;
    }
    
    NSString *filePath = [NSString stringWithFormat:@"%@/demo_binarized.tiff", [self applicationDocumentsDirectory]];
    NSURL *fileURL = [NSURL URLWithString:filePath];
    BOOL result = NO;
    if (self.images.count == 1) {
        result = [SBSDKTIFFImageWriter writeBinarizedTIFF:self.images[0] fileURL:fileURL];
    } else {
        result = [SBSDKTIFFImageWriter writeBinarizedMultiPageTIFF:self.images fileURL:fileURL];
    }
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
