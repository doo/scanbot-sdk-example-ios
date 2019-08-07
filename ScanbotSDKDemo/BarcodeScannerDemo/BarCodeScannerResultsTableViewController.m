//
//  BarCodeScannerResultsTableViewController.m
//  SBSDK Internal Demo
//
//  Created by Andrew Petrus on 24.01.19.
//  Copyright © 2019 doo GmbH. All rights reserved.
//

#import "BarCodeScannerResultsTableViewController.h"
#import "BarCodeScannerResultsTableViewCell.h"
#import "BarCodesResultDetailsViewController.h"

@interface BarCodeScannerResultsTableViewController ()

@property (nonatomic, strong) UIImage *selectedBarCodeImage;
@property (nonatomic, strong) NSString *selectedBarCodeText;
@property (nonatomic, strong) SBSDKBarCodeScannerDocumentFormat *selectedFormat;

@end

@implementation BarCodeScannerResultsTableViewController

- (NSString *)barcodeTypeStringRepresentation:(SBSDKBarcodeType)type {
    switch (type) {
        case SBSDKBarcodeTypeUnknown:
            return @"Unknown";
        case SBSDKBarcodeTypeUPCEANExtension:
            return @"UPC-EAN Extension";
        case SBSDKBarcodeTypeUPCE:
            return @"UPC-E";
        case SBSDKBarcodeTypeUPCA:
            return @"UPC-A";
        case SBSDKBarcodeTypeRSSExpanded:
            return @"RSS Expanded";
        case SBSDKBarcodeTypeRSS14:
            return @"RSS14";
        case SBSDKBarcodeTypeQRCode:
            return @"QR code";
        case SBSDKBarcodeTypePDF417:
            return @"PDF417";
        case SBSDKBarcodeTypeMaxicode:
            return @"Maxicode";
        case SBSDKBarcodeTypeITF:
            return @"ITF";
        case SBSDKBarcodeTypeEAN8:
            return @"EAN8";
        case SBSDKBarcodeTypeAztec:
            return @"Aztec";
        case SBSDKBarcodeTypeEAN13:
            return @"EAN13";
        case SBSDKBarcodeTypeCode39:
            return @"Code39";
        case SBSDKBarcodeTypeCode93:
            return @"Code93";
        case SBSDKBarcodeTypeCodaBar:
            return @"Codabar";
        case SBSDKBarcodeTypeCode128:
            return @"Code128";
        case SBSDKBarcodeTypeDataMatrix:
            return @"DataMatrix";
            
        default:
            return @"Unknown";
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showBarCodeDetailsVC"]) {
        BarCodesResultDetailsViewController *destinationVC = (BarCodesResultDetailsViewController *)segue.destinationViewController;
        destinationVC.barCodeImage = self.selectedBarCodeImage;
        destinationVC.barCodeText = self.selectedBarCodeText;
        destinationVC.barcodeFormat = self.selectedFormat;
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BarCodeScannerResultsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"barCodeResultCell"
                                                                               forIndexPath:indexPath];
    
    cell.barcodeText.text = self.results[indexPath.row].rawTextString;
    cell.barCodeType.text = [self barcodeTypeStringRepresentation:self.results[indexPath.row].type];
    cell.barcodeImage.image = self.results[indexPath.row].barcodeImage;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedBarCodeImage = self.results[indexPath.row].barcodeImage;
    self.selectedBarCodeText = self.results[indexPath.row].rawTextString;
    self.selectedFormat = self.results[indexPath.row].formattedResult;
    
    [self performSegueWithIdentifier:@"showBarCodeDetailsVC" sender:nil];
}

@end
