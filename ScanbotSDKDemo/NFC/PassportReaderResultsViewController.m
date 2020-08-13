//
//  PassportReaderResultsViewController.m
//  SBSDK Internal Demo
//
//  Created by Sebastian Husche on 11.05.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

#import "PassportReaderResultsViewController.h"
#import "PassportReaderResultTextTableViewCell.h"
#import "PassportReaderResultImageTableViewCell.h"
@import ScanbotSDK;

@interface PassportReaderResultsViewController() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) NSArray<SBSDKNFCDatagroup*>*datagroups;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation PassportReaderResultsViewController

+ (instancetype)makeWith:(NSArray<SBSDKNFCDatagroup *>*)datagroups {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PassportReaderResultsViewController *controller =
    [board instantiateViewControllerWithIdentifier:@"PassportReaderResultsViewController"];
    controller.datagroups = datagroups;
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SBSDKNFCDatagroup *group = self.datagroups[indexPath.section];
    id value = [group valueAtIndex:indexPath.row];
    if ([value isKindOfClass:[NSData class]]) {
        PassportReaderResultImageTableViewCell *cell =
        (PassportReaderResultImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"imageCell"];
        UIImage *image = [UIImage imageWithData:value];
        cell.photoView.image = image;
        return cell;
    } else {
        PassportReaderResultTextTableViewCell *cell =
        (PassportReaderResultTextTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"textCell"];
        cell.keyLabel.text = [group keyAtIndex:indexPath.row];
        
        if ([value isKindOfClass:[NSNumber class]]) {
            value = [value stringValue];
        }
        
        cell.valueLabel.text = [value length] > 0 ? value : @"---";
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datagroups.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datagroups[section].numberOfElements;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.datagroups[section].type;
}

@end
