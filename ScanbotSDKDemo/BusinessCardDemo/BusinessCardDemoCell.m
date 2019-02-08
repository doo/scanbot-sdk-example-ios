//
//  BusinessCardDemoCell.m
//  SBSDK Internal Demo
//
//  Created by Yevgeniy Knizhnik on 9/26/18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import "BusinessCardDemoCell.h"

@interface BusinessCardDemoCell ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation BusinessCardDemoCell

-(void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.image = self.image;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

@end
