//
//  BarCodeTypesListViewController.m
//  ScanbotSDK Demo
//
//  Created by Andrew Petrus on 13.05.19.
//  Copyright © 2019 doo GmbH. All rights reserved.
//

#import "BarCodeTypesListViewController.h"

@import ScanbotSDK;

@interface BarCodeTypesListViewController ()

@property (nonatomic, strong) NSMutableArray<SBSDKBarcodeType *> *selectedTypes;
@property (nonatomic, strong) NSArray<SBSDKBarcodeType *> *selectableTypes;

@end

@implementation BarCodeTypesListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.selectedTypes = [NSMutableArray arrayWithArray:self.selectedBarCodeTypes];
    self.selectableTypes = [SBSDKBarcodeType allTypes];
    
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
    return self.selectableTypes.count;
}

- (SBSDKBarcodeType *)barcodeTypeAtIndex:(NSUInteger)index {
    return self.selectableTypes[index];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"barCodeTypesListCell"
                                                            forIndexPath:indexPath];
    SBSDKBarcodeType *type = self.selectableTypes[indexPath.row];
    cell.textLabel.text = type.name;
    cell.accessoryType = [self.selectedTypes containsObject:type] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SBSDKBarcodeType *type = self.selectableTypes[indexPath.row];
    if ([self.selectedTypes containsObject:type]) {
        [self.selectedTypes removeObject:type];
    } else {
        [self.selectedTypes addObject:type];
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

@end
