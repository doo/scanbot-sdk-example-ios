//
//  BusinessCardDetailDemoViewController.m
//  SBSDK Internal Demo
//
//  Created by Yevgeniy Knizhnik on 9/26/18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import "BusinessCardDetailDemoViewController.h"

@implementation BusinessCard

- (instancetype)initWith:(UIImage *)image recognizedText:(NSString *)text {
    self = [super init];
    if (self) {
        _image = image;
        _recognizedText = text;
    }
    return self;
}

@end

@interface BusinessCardDetailDemoViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@end

@implementation BusinessCardDetailDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateBusinessCard];
}

- (void)setBusinessCard:(BusinessCard *)businessCard {
    _businessCard = businessCard;
    [self updateBusinessCard];
}

- (void)updateBusinessCard {
    if (self.isViewLoaded) {
        self.imageView.image = self.businessCard.image;
        self.textView.text = self.businessCard.recognizedText;
    }
}

@end
