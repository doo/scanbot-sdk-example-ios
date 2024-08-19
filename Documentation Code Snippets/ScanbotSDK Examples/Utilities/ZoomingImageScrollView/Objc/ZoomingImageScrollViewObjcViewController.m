//
//  ZoomingImageScrollViewObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 01.12.22.
//

#import "ZoomingImageScrollViewObjcViewController.h"
@import ScanbotSDK;

@interface ZoomingImageScrollViewObjcViewController ()

@end

@implementation ZoomingImageScrollViewObjcViewController

SBSDKZoomingImageScrollView *imageViewWithZoom;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"documentImage"];
    
    // We instantiate our new class helper.
    imageViewWithZoom = [[SBSDKZoomingImageScrollView alloc] init];
    
    // We set the desired image.
    imageViewWithZoom.image = image;
    
    // We can add some margins.
    imageViewWithZoom.margins = UIEdgeInsetsMake(0, 20, 0, 20);
    
    // We set an overlay on top of our image.
    UIView *overlayView = [[UIView alloc] init];
    overlayView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    imageViewWithZoom.overlayView = overlayView;
    
    // We add our view to the subview with our desired constraints.
    imageViewWithZoom.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:imageViewWithZoom];
    if (image != nil) {
        CGFloat ratio = image.size.width / image.size.height;
        [imageViewWithZoom.widthAnchor constraintEqualToConstant:320].active = YES;
        [imageViewWithZoom.heightAnchor constraintEqualToConstant:320 / ratio].active = YES;
        
        [imageViewWithZoom.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
        [imageViewWithZoom.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;

    }
}
@end
