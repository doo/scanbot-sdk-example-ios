//
//  GenericDocumentResultViewController.m
//  SBSDK Internal Demo
//
//  Created by Sebastian Husche on 22.05.20.
//  Copyright © 2020 doo GmbH. All rights reserved.
//

#import "GenericDocumentResultViewController.h"
#import "GenericDocumentFieldTableViewCell.h"

@interface GenericDocumentResultViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SBSDKGenericDocument *document;
@property (nonatomic, strong) NSArray<SBSDKGenericDocument *> *flatDocument;
@property (nonatomic, strong) UIImage* sourceImage;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

@implementation GenericDocumentResultViewController

+ (instancetype)makeWithResult:(SBSDKGenericDocument *)document sourceImage:(UIImage *)sourceImage {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GenericDocumentResultViewController *controller =
    [storyboard instantiateViewControllerWithIdentifier:@"GenericDocumentResultViewController"];
    controller.document = document;
    controller.sourceImage = sourceImage;
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.flatDocument = [self.document flatDocumentIncludingEmptyChildren:NO includingEmptyFields:NO];
    
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
    return self.flatDocument.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.flatDocument[section].type.displayText;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.flatDocument[section].fields.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GenericDocumentFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fieldCell"];
    SBSDKGenericDocumentField *field = self.flatDocument[indexPath.section].fields[indexPath.row];
    cell.fieldTypeLabel.text = field.type.name;
    
    UIImage *image = [field.image sbsdk_limitedToSize:CGSizeMake(10000.0, 80.0f)];
    cell.fieldImageView.image = image;
    
    if (field.value.text.length > 0) {
        cell.recognizedTextLabel.text = field.value.text;

        cell.recognizedTextInfoLabel.text
        = [NSString stringWithFormat:@"Recognized text with confidence %0.2f %%", field.value.confidence * 100.0f];
        
    } else {
        cell.recognizedTextInfoLabel.text = @"";
        cell.recognizedTextLabel.text = @"";
    }
    return cell;
}

- (NSString *)textForType:(SBSDKGenericDocumentType *)type {
    if (type.displayText != nil) {
        return type.displayText;
    }
    return type.name;
}

@end
