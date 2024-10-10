//
//  GenericDocumentUIObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Sebastian Husche on 06.05.21.
//

#import "GenericDocumentUIObjcViewController.h"
@import ScanbotSDK;

@interface GenericDocumentUIObjcViewController () <SBSDKUIGenericDocumentRecognizerViewControllerDelegate>

@end

@implementation GenericDocumentUIObjcViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Start scanning here. Usually this is an action triggered by some button or menu.
    [self startScanning];
}

- (void)startScanning {

    // Create the default configuration object.
    SBSDKUIGenericDocumentRecognizerConfiguration *configuration
    = [SBSDKUIGenericDocumentRecognizerConfiguration defaultConfiguration];

    // Customize the behavior, user interface and text.

    // Behavior configuration:
    // Select one of the following document types:
    // German ID card. Front and/or back side.
    configuration.behaviorConfiguration.documentType = [SBSDKUIDocumentType idCardFrontBackDE];

    // Or German driver's license. Front and/or back side.
    // configuration.behaviorConfiguration.documentType = [SBSDKUIDocumentType driverLicenseFrontBackDE];

    // Or German passport. Single sided.
    // configuration.behaviorConfiguration.documentType = [SBSDKUIDocumentType passportDE];

    // Select the field types that should be excluded from the recognition process.
    configuration.behaviorConfiguration.excludedFieldTypes = @[SBSDKGenericDocumentConstants.mrzGenderFieldNormalizedName,
                                                               SBSDKGenericDocumentConstants.mrzIssuingAuthorityFieldNormalizedName,
                                                               SBSDKGenericDocumentConstants.deIdCardFrontNationalityFieldNormalizedName];

    // Turn the flashlight on/off.
    configuration.behaviorConfiguration.isFlashEnabled = NO;


    // UI configuration:
    // configure various colors.
    configuration.uiConfiguration.detailsBackgroundColor = [UIColor darkGrayColor];
    configuration.uiConfiguration.detailsSectionHeaderBackgroundColor = [UIColor darkGrayColor];

    // Customize the visibility of certain fields in the recognized fields list.
    // Print the field type visibilities, if needed.
    // NSLog("%@", configuration.uiConfig0uration.fieldTypeVisibilities)

    // Always show the eye-color field in the recognized fields list.
//    configuration.uiConfiguration.fieldTypeVisibilities[@"DeIdCardBack.EyeColor"]
//    = SBSDKGenericDocumentFieldDisplayStateAlwaysVisible;
    
    // Show the categories field in the recognized fields list if the field has a value, otherwise it is hidden.
//    configuration.uiConfiguration.fieldTypeVisibilities[@"DeDriverLicenseFront.LicenseCategories"]
//    = SBSDKGenericDocumentFieldDisplayStateVisibleIfNotEmpty;


    // Text configuration:
    // customize UI elements' texts.
    configuration.textConfiguration.cancelButtonTitle = @"Abort";
    configuration.textConfiguration.clearButtonTitle = @"Reset";

    // Customize document type and field type names. Used also for internationalisation.
    // Print the document type texts if needed.
    // NSLog(@"%@", configuration.textConfiguration.documentTypeDisplayTexts);

    // Change/localize the display text for the front side of a German ID card.
//    configuration.textConfiguration.documentTypeDisplayTexts[@"DeIdCardFront"] = @"Personalausweis (Vorderseite)";

    // Print the field type texts if needed.
    // NSLog(@"%@", configuration.textConfiguration.fieldTypeDisplayTexts);
    // Change/localize the display text for the surname field on the front side of a German ID card.
//    configuration.textConfiguration.fieldTypeDisplayTexts[@"DeDriverLicenseFront.Surname"] = @"Nachname";

    // Present the recognizer view controller modally on this view controller.
    [SBSDKUIGenericDocumentRecognizerViewController presentOn:self configuration:configuration delegate:self];
}

// The delegate function implementation.
- (void)genericDocumentRecognizerViewController:(nonnull SBSDKUIGenericDocumentRecognizerViewController *)viewController
                         didFinishWithDocuments:(nonnull NSArray<SBSDKGenericDocument *> *)documents {

    // Get the first document. In case of multiple documents, e.g. front side and back side, you need to
    // handle all of them.
    SBSDKGenericDocument *document = documents.firstObject;
    if (document == nil) {
        return;
    }

    // Access the document's fields directly by iterating over the document's fields.
    for (SBSDKGenericDocumentField *field in document.fields) {
        // Print field type name, field text and field confidence to the console.
        NSLog(@"%@ = %@ (Confidence: %0.3f)", field.type.name, field.value.text, field.value.confidence);
    }

    // Or get a field by its name.
    SBSDKGenericDocumentField *nameField = [document fieldByTypeName:@"Surname"];
    if (nameField != nil) {
        // Access various properties of the field.
        NSString *fieldTypeName = nameField.type.name;
        NSString* fieldValue = nameField.value.text;
        float confidence = nameField.value.confidence;
    }

    // Or create a wrapper for the document if needed.
    // You must cast it to the specific wrapper subclass.
    SBSDKGenericDocumentWrapper *wrapper = [document wrap];
    // Check the subclass...
    if ([wrapper isKindOfClass:[SBSDKGenericDocumentDeIdCardFront class]]) {
        // ... and cast it.
        SBSDKGenericDocumentDeIdCardFront* frontSideWrapper = (SBSDKGenericDocumentDeIdCardFront*)wrapper;
        // Access the document's fields easily through the wrapper.
        NSString *fieldTypeName = frontSideWrapper.surname.type.name;
        NSString* fieldValue = frontSideWrapper.surname.value.text;
        float confidence = frontSideWrapper.surname.value.confidence;
    }
}

@end
