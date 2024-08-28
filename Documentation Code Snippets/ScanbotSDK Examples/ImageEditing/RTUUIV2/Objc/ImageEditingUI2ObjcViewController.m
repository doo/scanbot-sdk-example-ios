//
//  ImageEditingUI2ObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 02.08.24.
//

#import <Foundation/Foundation.h>

#import "ImageEditingUI2ObjcViewController.h"
@import ScanbotSDK;

@interface ImageEditingUI2ObjcViewController ()

@end

@implementation ImageEditingUI2ObjcViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Retrieve the scanned document
    SBSDKScannedDocument *document = [[SBSDKScannedDocument alloc] initWithDocumentUuid:@"SOME_SAVED_UUID"];
    
    // Retrieve the selected document page.
    SBSDKScannedPage *page = [document pageAt:0];
    
    // Create the default configuration object.
    SBSDKUI2CroppingConfiguration *configuration = [[SBSDKUI2CroppingConfiguration alloc] initWithDocumentUuid:document.uuid pageUuid:page.uuid];
    
    // e.g disable the rotation feature.
    configuration.cropping.bottomBar.rotateButton.visible = NO;
    
    // e.g. configure various colors.
    configuration.appearance.topBarBackgroundColor = [[SBSDKUI2Color alloc] initWithUiColor: [UIColor redColor]];
    configuration.cropping.topBarConfirmButton.foreground.color = [[SBSDKUI2Color alloc] initWithUiColor: [UIColor whiteColor]];
    
    // e.g. customize a UI element's text
    configuration.localization.croppingCancelButtonTitle = @"Cancel";
    
    // Present the recognizer view controller modally on this view controller.
    [SBSDKUI2CroppingViewController presentOn:self configuration:configuration completion:^(SBSDKUI2CroppingResult * _Nonnull result) {
        
        // Completion handler to process the result.
        if (result.errorMessage != nil) {
            // There was an error.
            NSLog(@"%@", result.errorMessage);
        } else {
            // The screen is dismissed without errors.
        }
    }];
}
@end
