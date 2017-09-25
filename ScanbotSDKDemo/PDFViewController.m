//
//  PDFViewController.m
//  PayFormScannerDemo
//
//  Created by Sebastian Husche on 24.06.15.
//  Copyright (c) 2015 doo GmbH. All rights reserved.
//

#import "PDFViewController.h"

@interface PDFViewController ()
@property (strong, nonatomic) IBOutlet UIView *webViewContainer;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;
@end

@implementation PDFViewController

+ (PDFViewController *)pdfControllerWithURL:(NSURL *)pdfURL {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PDFViewController  *pdfViewController = (PDFViewController *)[storyBoard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    pdfViewController.pdfURL = pdfURL;
    return pdfViewController;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.pdfURL) {
        [[NSFileManager defaultManager] removeItemAtURL:self.pdfURL error:nil];
        self.pdfURL = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:self.webViewContainer.bounds];
    self.webView.translatesAutoresizingMaskIntoConstraints = YES;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.webViewContainer addSubview:self.webView];
    [self loadPDF];
}

- (void)loadPDF {
    if (!self.pdfURL || !self.webView) {
        return;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.pdfURL];
    [self.webView loadRequest:request];
}

- (IBAction)share:(id)sender {
    if (self.pdfURL) {
        self.documentInteractionController
        = [UIDocumentInteractionController interactionControllerWithURL:self.pdfURL];
        [self.documentInteractionController presentOpenInMenuFromBarButtonItem:sender animated:YES];
    }
}


@end
