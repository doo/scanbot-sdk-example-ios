//
//  BarCodeTypesListViewController.m
//  SBSDK Internal Demo
//
//  Created by Andrew Petrus on 13.05.19.
//  Copyright © 2019 doo GmbH. All rights reserved.
//

#import "BarCodeTypesListViewController.h"
#import "BarCodeTypesListTableViewCell.h"
@import ScanbotSDK;

@interface BarCodeTypesListViewController ()

@property (nonatomic, strong) NSMutableArray<NSNumber *> *selectedTypes;

@end

@implementation BarCodeTypesListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.selectedTypes = [NSMutableArray arrayWithArray:self.selectedBarCodeTypes];
    [self.tableView reloadData];
}

- (IBAction)applyButtonTapped:(id)sender {
    if (self.delegate) {
        [self.delegate barCodeTypesSelectionChanged:[NSArray arrayWithArray:self.selectedTypes]];
    }
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 17;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.selectedTypes containsObject:@(indexPath.row)]) {
        [tableView selectRowAtIndexPath:indexPath
                               animated:NO
                         scrollPosition:UITableViewScrollPositionNone];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BarCodeTypesListTableViewCell *cell = (BarCodeTypesListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"barCodeTypesListCell"
                                                                                                           forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.barCodeTypaNameLabel.text = @"Aztec";
            break;
            
        case 1:
            cell.barCodeTypaNameLabel.text = @"Codabar";
            break;
            
        case 2:
            cell.barCodeTypaNameLabel.text = @"Code39";
            break;
            
        case 3:
            cell.barCodeTypaNameLabel.text = @"Code93";
            break;
            
        case 4:
            cell.barCodeTypaNameLabel.text = @"Code128";
            break;
            
        case 5:
            cell.barCodeTypaNameLabel.text = @"DataMatrix";
            break;
            
        case 6:
            cell.barCodeTypaNameLabel.text = @"EAN8";
            break;
            
        case 7:
            cell.barCodeTypaNameLabel.text = @"EAN13";
            break;
            
        case 8:
            cell.barCodeTypaNameLabel.text = @"ITF";
            break;
            
        case 9:
            cell.barCodeTypaNameLabel.text = @"Maxicode";
            break;
            
        case 10:
            cell.barCodeTypaNameLabel.text = @"PDF417";
            break;
            
        case 11:
            cell.barCodeTypaNameLabel.text = @"QR";
            break;
            
        case 12:
            cell.barCodeTypaNameLabel.text = @"RSS14";
            break;
            
        case 13:
            cell.barCodeTypaNameLabel.text = @"RSS Expanded";
            break;
        
        case 14:
            cell.barCodeTypaNameLabel.text = @"UPC-A";
            break;
            
        case 15:
            cell.barCodeTypaNameLabel.text = @"UPC-E";
            break;
            
        case 16:
            cell.barCodeTypaNameLabel.text = @"UPC EAN Extension";
            break;
            
        default:
            cell.barCodeTypaNameLabel.text = @"UNKNOWN";
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.selectedTypes removeObject:@(indexPath.row)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![self.selectedTypes containsObject:@(indexPath.row)]) {
        [self.selectedTypes addObject:@(indexPath.row)];
    }
}

@end
