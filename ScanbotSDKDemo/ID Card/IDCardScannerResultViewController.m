//
//  IDCardScannerResultViewController.m
//  SBSDK Internal Demo
//
//  Created by Sebastian Husche on 22.05.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

#import "IDCardScannerResultViewController.h"
#import "IDCardResultGeneralTableViewCell.h"
#import "IDCardResultFieldTableViewCell.h"

@interface IDCardScannerResultViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) SBSDKIDCardRecognizerResult *result;
@property (nonatomic, strong) UIImage *sourceImage;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@end

@implementation IDCardScannerResultViewController

+ (instancetype)makeWithResult:(SBSDKIDCardRecognizerResult *)result  sourceImage:(UIImage *)sourceImage {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    IDCardScannerResultViewController *controller =
    [storyboard instantiateViewControllerWithIdentifier:@"IDCardScannerResultViewController"];
    controller.result = result;
    controller.sourceImage = sourceImage;
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0f;
    [self.tableView reloadData];
}

- (IBAction)shareSourceImage:(id)sender {
    if (self.sourceImage == nil) {
        return;
    }
    
    UIActivityViewController *activityViewController
    = [[UIActivityViewController alloc]initWithActivityItems:@[self.sourceImage] applicationActivities:nil];
    activityViewController.popoverPresentationController.sourceView = self.view;
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Recognized Fields";
        case 1:
            return @"Machine Readable Zone Fields";
        default:
            return @"Machine Readable Zone Check Digits";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1 + self.result.fields.count;
    } else if (section == 1) {
        return self.result.mrzFields.count;
    } else {
        return self.result.mrzCheckDigits.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            IDCardResultGeneralTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"generalCell"];
            cell.titleLabel.text = self.result.type.cardTypeName;
            cell.titleImageView.image = [self.result croppedImage];
            return cell;
        } else {
            IDCardResultFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fieldCell"];
            SBSDKIDCardRecognizerResultField *field = self.result.fields[indexPath.row - 1];
            
            cell.fieldTypeLabel.text = [self fieldTypeTextForField:field];
            UIImage *image = [field.image sbsdk_limitedToSize:CGSizeMake(10000.0, 80.0f)];
            cell.fieldImageView.image = image;
            if (field.text.length > 0) {
                cell.recognizedTextInfoLabel.text
                = [NSString stringWithFormat:@"Recognized text with confidence %0.2f %%", field.textConfidence * 100.0f];
                cell.recognizedTextLabel.text = field.text;
            } else {
                cell.recognizedTextInfoLabel.text = @"";
                cell.recognizedTextLabel.text = @"";
            }
            return cell;
        }
    } else if (indexPath.section == 1) {
        IDCardResultFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fieldCell"];
        SBSDKMachineReadableZoneRecognizerField *field = self.result.mrzFields[indexPath.row];
        cell.fieldTypeLabel.text = [self fieldTypeTextForMRZField:field];
        cell.fieldImageView.image = nil;
        if (field.value.length > 0) {
            cell.recognizedTextInfoLabel.text
            = [NSString stringWithFormat:@"Recognized text with confidence %0.2f %%", field.averageRecognitionConfidence * 100.0f];
            cell.recognizedTextLabel.text = field.value;
        } else {
            cell.recognizedTextInfoLabel.text = @"";
            cell.recognizedTextLabel.text = @"";
        }
        return cell;
    } else {
        IDCardResultFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fieldCell"];
        SBSDKMachineReadableZoneRecognizerResultCheckDigit *field = self.result.mrzCheckDigits[indexPath.row];
        cell.fieldTypeLabel.text = field.validatedString;
        cell.fieldImageView.image = nil;
        return cell;
    }
}

- (NSString *)fieldTypeTextForMRZField:(SBSDKMachineReadableZoneRecognizerField *)field {
    NSString *typeString = @"";
    switch (field.fieldName) {
        case SBSDKMachineReadableZoneRecognizerFieldNameTravelDocumentType:
            typeString = @"MRZ Document type";
            break;
        case SBSDKMachineReadableZoneRecognizerFieldNameKindOfDocument:
            typeString = @"MRZ Document type variant";
            break;
        case SBSDKMachineReadableZoneRecognizerFieldNameIssuingStateOrOrganization:
            typeString = @"MRZ Issuing authority";
            break;
        case SBSDKMachineReadableZoneRecognizerFieldNameDocumentCode:
            typeString = @"MRZ Document number";
            break;
        case SBSDKMachineReadableZoneRecognizerFieldNameOptional1:
            typeString = @"MRZ Optional 1";
            break;
        case SBSDKMachineReadableZoneRecognizerFieldNameDateOfBirth:
            typeString = @"MRZ Birth date";
            break;
        case SBSDKMachineReadableZoneRecognizerFieldNameGender:
            typeString = @"MRZ Gender";
            break;
        case SBSDKMachineReadableZoneRecognizerFieldNameDateOfExpiry:
            typeString = @"MRZ Expiry date";
            break;
        case SBSDKMachineReadableZoneRecognizerFieldNameNationality:
            typeString = @"MRZ Nationality";
            break;
        case SBSDKMachineReadableZoneRecognizerFieldNameOptional2:
            typeString = @"MRZ Optional 2";
            break;
        case SBSDKMachineReadableZoneRecognizerFieldNameLastName:
            typeString = @"MRZ Surname";
            break;
        case SBSDKMachineReadableZoneRecognizerFieldNameFirstName:
            typeString = @"MRZ Given names";
            break;
        default:
            typeString = @"";
            break;
    }
    return [NSString stringWithFormat:@"Field type: %@", typeString];
}

- (NSString *)fieldTypeTextForField:(SBSDKIDCardRecognizerResultField *)field {
    NSString *typeString = @"";
    switch (field.type) {
        case SBSDKIDCardFieldTypeInvalid:
            typeString = @"Invalid";
            break;
        case SBSDKIDCardFieldTypeID:
            typeString = @"ID";
            break;
        case SBSDKIDCardFieldTypeSurname:
            typeString = @"Surname";
            break;
        case SBSDKIDCardFieldTypeMaidenName:
            typeString = @"Maiden name";
            break;
        case SBSDKIDCardFieldTypeGivenNames:
            typeString = @"Given name";
            break;
        case SBSDKIDCardFieldTypeBirthDate:
            typeString = @"Birth date";
            break;
        case SBSDKIDCardFieldTypeNationality:
            typeString = @"Nationality";
            break;
        case SBSDKIDCardFieldTypeBirthplace:
            typeString = @"Birth place";
            break;
        case SBSDKIDCardFieldTypeExpiryDate:
            typeString = @"Expiry date";
            break;
        case SBSDKIDCardFieldTypePIN:
            typeString = @"PIN";
            break;
        case SBSDKIDCardFieldTypeEyeColor:
            typeString = @"Eye color";
            break;
        case SBSDKIDCardFieldTypeHeight:
            typeString = @"Height";
            break;
        case SBSDKIDCardFieldTypeIssueDate:
            typeString = @"Issue date";
            break;
        case SBSDKIDCardFieldTypeIssuingAuthority:
            typeString = @"Issuing authority";
            break;
        case SBSDKIDCardFieldTypeAddress:
            typeString = @"Address";
            break;
        case SBSDKIDCardFieldTypePseudonym:
            typeString = @"Pseudonym";
            break;
        case SBSDKIDCardFieldTypeMRZ:
            typeString = @"MRZ data";
            break;
        case SBSDKIDCardFieldTypeSignature:
            typeString = @"Signature";
            break;
        case SBSDKIDCardFieldTypePhoto:
            typeString = @"Photo";
            break;
        case SBSDKIDCardFieldTypePassportType:
            typeString = @"Passport type";
            break;
        case SBSDKIDCardFieldTypeCountryCode:
            typeString = @"Country code";
            break;
        case SBSDKIDCardFieldTypeGender:
            typeString = @"Gender";
            break;
    }
    return [NSString stringWithFormat:@"Field type: %@", typeString];
}
@end
