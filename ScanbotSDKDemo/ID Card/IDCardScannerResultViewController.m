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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + self.result.fields.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        IDCardResultGeneralTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"generalCell"];
        cell.titleLabel.text = [self textForType:self.result.type];
        cell.titleImageView.image = [self.result croppedImage];
        return cell;
    } else {
        IDCardResultFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fieldCell"];
        SBSDKIDCardRecognizerResultField *field = self.result.fields[indexPath.row - 1];
        
        cell.fieldTypeLabel.text = [self fieldTypeTextForField:field];
        if (field.binarizedImage != nil) {
            cell.fieldImageView.image = field.binarizedImage;
        } else {
            cell.fieldImageView.image = field.image;
        }
        
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
}

- (NSString *)textForType:(SBSDKIDCardType)type {
    switch (type) {
        case SBSDKIDCardTypeBack_DE:
            return @"Back Side DE";
        case SBSDKIDCardTypeFront_DE:
            return @"Front Side DE";
        case SBSDKIDCardTypePassport_DE:
            return @"Passport DE";
        case SBSDKIDCardTypeUnknown:
            return @"Unknown";
    }
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
