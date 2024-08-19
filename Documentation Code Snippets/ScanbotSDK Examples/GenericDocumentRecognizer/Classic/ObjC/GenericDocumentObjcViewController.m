//
//  GenericDocumentObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Sebastian Husche on 06.05.21.
//

#import "GenericDocumentObjcViewController.h"
@import ScanbotSDK;

// This is a simple, empty view controller which acts as a container and delegate for the SBSDKGenericDocumentRecognizerViewController.
@interface GenericDocumentObjcViewController () <SBSDKGenericDocumentRecognizerViewControllerDelegate>

// The instance of the recognition view controller.
@property (nonatomic, strong) SBSDKGenericDocumentRecognizerViewController* recognizerController;

@end


@implementation GenericDocumentObjcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Define the types of documents that should be recognized.
    // Recognize all supported document types.
    NSArray *allTypes = [SBSDKGenericDocumentRootType allDocumentTypes];
    
    // Recognize German ID cards only. Front and/or back side.
    NSArray *idCardTypes = @[
        [SBSDKGenericDocumentRootType deIdCardFront],
        [SBSDKGenericDocumentRootType deIdCardBack]
    ];
    
    // Recognize German passports. Front side only.
    NSArray *passportTypes = @[
        [SBSDKGenericDocumentRootType dePassport]
    ];
    
    // Recognize German driver's licenses only. Front and/or back side.
    NSArray *driverLicenseTypes = @[
        [SBSDKGenericDocumentRootType deDriverLicenseFront],
        [SBSDKGenericDocumentRootType deDriverLicenseBack]
    ];
    
    // Exclude these field types from recognition process
    NSArray *excludedTypes = @[[SBSDKGenericDocumentConstants mrzGenderFieldNormalizedName],
                               [SBSDKGenericDocumentConstants mrzIssuingAuthorityFieldNormalizedName],
                               [SBSDKGenericDocumentConstants deIdCardFrontNationalityFieldNormalizedName]];
    
    // Create the SBSDKGenericDocumentRecognizerViewController instance
    // and let it embed into this view controller's view.
    self.recognizerController
    = [[SBSDKGenericDocumentRecognizerViewController alloc] initWithParentViewController:self
       // Embed the recognizer in this view controller's view.
                                                                              parentView:self.view
       // Pass the above types here as required.
                                                                   acceptedDocumentTypes:allTypes
       // Pass the above excluded types here to exclude them from recognition process
                                                                      excludedFieldTypes:excludedTypes
       // Set the delegate to this view controller.
                                                                                delegate:self];
        
    // Define additional configuration of the recognizer view controller.
    
    // Turn the flashlight on/off.
    self.recognizerController.isFlashLightEnabled = NO;
    
    // Configure the viewfinder.
    // Get current view finder configuration object.
    SBSDKBaseScannerViewFinderConfiguration *config = self.recognizerController.viewFinderConfiguration;
    
    // Enable the view finder.
    config.isViewFinderEnabled = YES;
    
    // Configure the view finder colors and line properties.
    config.lineColor = [UIColor redColor];
    config.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
    config.lineWidth = 2;
    config.lineCornerRadius = 8;
    
    // Set the view finder configuration to apply it.
    self.recognizerController.viewFinderConfiguration = config;
}

// The delegate implementation of SBSDKGenericDocumentViewController.
- (void)documentRecognizerViewController:(SBSDKGenericDocumentRecognizerViewController *)controller
                      didRecognizeResult:(SBSDKGenericDocumentRecognitionResult *)result
                                 onImage:(UIImage *)image {
        
    // Access the documents fields directly by iterating over the documents fields.
    for (SBSDKGenericDocumentField *field in result.document.fields) {
        // Print field type name, field text and field confidence to the console.
        NSLog(@"%@ = %@ (Confidence: %0.3f)", field.type.name, field.value.text, field.value.confidence);
    }
    
    // Or get a field by it's name.
    SBSDKGenericDocumentField *nameField = [result.document fieldByTypeName:@"Surname"];
    if (nameField != nil) {
        // Access various properties of the field.
        NSString *fieldTypeName = nameField.type.name;
        NSString* fieldValue = nameField.value.text;
        float confidence = nameField.value.confidence;
    }
    
    // Or create a wrapper for the document if needed.
    // You must cast it to the specific wrapper subclass.
    SBSDKGenericDocumentWrapper *wrapper = [result.document wrap];
    // Check the subclass...
    if ([wrapper isKindOfClass:[SBSDKGenericDocumentDeIdCardFront class]]) {
        // ... and cast it.
        SBSDKGenericDocumentDeIdCardFront* frontSideWrapper = (SBSDKGenericDocumentDeIdCardFront*)wrapper;
        // Access the documents fields easily through the wrapper.
        NSString *fieldTypeName = frontSideWrapper.surname.type.name;
        NSString* fieldValue = frontSideWrapper.surname.value.text;
        float confidence = frontSideWrapper.surname.value.confidence;
    }
}

@end
