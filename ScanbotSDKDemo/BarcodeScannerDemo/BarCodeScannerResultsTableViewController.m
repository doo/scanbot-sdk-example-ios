//
//  BarCodeScannerResultsTableViewController.m
//  ScanbotSDK Demo
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
@property (nonatomic, strong) NSData *barCodeRawData;

@end

@implementation BarCodeScannerResultsTableViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showBarCodeDetailsVC"]) {
        BarCodesResultDetailsViewController *destinationVC = (BarCodesResultDetailsViewController *)segue.destinationViewController;
        destinationVC.barCodeImage = self.selectedBarCodeImage;
        destinationVC.barCodeText = self.selectedBarCodeText;
        destinationVC.barcodeFormat = self.selectedFormat;
        destinationVC.barCodeRawBytes = self.barCodeRawData;
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
    cell.barCodeType.text = self.results[indexPath.row].type.name;
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
    self.barCodeRawData = self.results[indexPath.row].rawBytes;
    
    [self performSegueWithIdentifier:@"showBarCodeDetailsVC" sender:nil];
}

@end
