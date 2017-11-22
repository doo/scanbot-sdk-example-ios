//
//  QRDescriptionViewController.m
//  SBSDK Internal Demo
//
//  Created by Yevgeniy Knizhnik on 10/11/17.
//  Copyright © 2017 doo GmbH. All rights reserved.
//

#import "QRDescriptionViewController.h"
#import "ScanbotSDKInclude.h"
#import <MessageUI/MessageUI.h>

@import Contacts;
@import ContactsUI;

@interface QRDescriptionViewController () <CNContactViewControllerDelegate, MFMessageComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;
@property (strong, nonatomic) IBOutlet UIView *popupView;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *bubbleConstraints;
@property (strong, nonatomic) IBOutlet UIStackView *mainStackView;
@property (strong, nonatomic) IBOutlet UIStackView *buttonsStackView;
@property (strong, nonatomic) IBOutlet UIButton *upperButton;
@property (strong, nonatomic) IBOutlet UIButton *lowerButton;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;

@property (assign, nonatomic) BOOL isProcessed;
@end

@implementation QRDescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.popupView.layer.cornerRadius = self.cornerRadius;
    self.isProcessed = NO;
    self.popupView.backgroundColor = self.color;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.isProcessed) {
        [self processCode];
    }
}

- (void)processCode {
    NSString *buttonTitle = [[NSMutableString alloc] init];
    NSMutableString *text = [[NSMutableString alloc] initWithString:@""];
    if ([self.code isKindOfClass:[SBSDKContactQRCode class]]) {
        CNContact *contact = ((SBSDKContactQRCode *) self.code).contact;
        [text appendString:[NSMutableString stringWithFormat:@"Name: %@; \n", contact.givenName]];
        [text appendString:[NSString stringWithFormat:@"Middle Name: %@; \n", contact.middleName]];
        [text appendString:[NSString stringWithFormat:@"Surname: %@; \n", contact.familyName]];
        [text appendString:[NSString stringWithFormat:@"Phone: %@; \n", contact.phoneNumbers.firstObject.value.stringValue]];
        [text appendString:[NSString stringWithFormat:@"Organization: %@; \n", contact.organizationName]];
        [text appendString:[NSString stringWithFormat:@"Department: %@; \n", contact.departmentName]];
        [text appendString:[NSString stringWithFormat:@"Job title: %@; \n", contact.jobTitle]];
        [text appendString:[NSString stringWithFormat:@"Email: %@; \n", contact.emailAddresses.firstObject.value]];
        [text appendString:[NSString stringWithFormat:@"Web: %@; \n", contact.urlAddresses.firstObject.value]];
        buttonTitle = @"Save to contacts";
    } else if ([self.code isKindOfClass:[SBSDKShortMessageQRCode class]]) {
        SBSDKShortMessageQRCode *code = (SBSDKShortMessageQRCode *) self.code;
        [text appendString:@"Recepients: "];
        for (NSString *recepient in code.recipients) {
            [text appendString:[NSString stringWithFormat:@"\n %@", recepient]];
        }
        [text appendString:[NSString stringWithFormat:@"\n\n Body: \n%@", code.body]];

        buttonTitle = @"Send SMS";
    } else if ([self.code isKindOfClass:[SBSDKWebURLQRCode class]]) {
        SBSDKWebURLQRCode *code = (SBSDKWebURLQRCode *) self.code;
        [text appendString:code.webURL.absoluteString];
        buttonTitle = @"Open URL";
    } else if ([self.code isKindOfClass:[SBSDKMailMessageQRCode class]]) {
        SBSDKMailMessageQRCode *code = (SBSDKMailMessageQRCode *) self.code;
        [text appendString:@"Recepients: "];
        for (NSString *recepient in code.recipients) {
            [text appendString:[NSString stringWithFormat:@"\n %@", recepient]];
        }
        [text appendString:[NSString stringWithFormat:@"\n Subject: \n%@", code.subject]];
        [text appendString:[NSString stringWithFormat:@"\n Body: \n%@", code.body]];
        buttonTitle = @"Send Email";
    } else if ([self.code isKindOfClass:[SBSDKEventQRCode class]]) {
        SBSDKEventQRCode *code = (SBSDKEventQRCode *) self.code;
        [text appendString:code.summary];
        [text appendString:[NSString stringWithFormat:@"\n Date:%@ - %@", code.startDate, code.endDate]];
        buttonTitle = @"Save to Calendar";
    } else if ([self.code isKindOfClass:[SBSDKPhoneNumberQRCode class]]) {
        SBSDKPhoneNumberQRCode *code = (SBSDKPhoneNumberQRCode *) self.code;
        [text appendString:[NSString stringWithFormat:@"Phone number:\n%@", code.phoneNumber]];
        buttonTitle = @"Save to contacts";
    } else if ([self.code isKindOfClass:[SBSDKLocationQRCode class]]) {
        SBSDKLocationQRCode *code = (SBSDKLocationQRCode *) self.code;
        [text appendString:[NSString stringWithFormat:@"Latitude: %f", code.location.coordinate.latitude]];
        [text appendString:[NSString stringWithFormat:@"\nLongitude: %f", code.location.coordinate.longitude]];
        buttonTitle = @"Show on map";
    } else if ([self.code isKindOfClass:[SBSDKWiFiHotspotQRCode class]]) {
        SBSDKWiFiHotspotQRCode *code = (SBSDKWiFiHotspotQRCode *) self.code;
        [text appendString:[NSString stringWithFormat:@"SSID: %@", code.SSID]];
        [text appendString:[NSString stringWithFormat:@"\nPassword: %@", code.password]];
    } else {
        [text appendString:self.code.stringValue];
    }
    self.infoLabel.text = text;
    [self.lowerButton setTitle:buttonTitle forState:UIControlStateNormal];
    if (buttonTitle.length > 0) {
        [self.buttonsStackView addArrangedSubview:self.lowerButton];
    }
    self.isProcessed = YES;
}

- (void)addContact {
    CNContact *contact;
    if ([self.code isKindOfClass:[SBSDKContactQRCode class]]) {
        contact = ((SBSDKContactQRCode *) self.code).contact;
    } else if ([self.code isKindOfClass:[SBSDKPhoneNumberQRCode class]]) {
        CNMutableContact *newContact = [[CNMutableContact alloc] init];
        newContact.phoneNumbers = @[[[CNLabeledValue alloc] initWithLabel:CNLabelPhoneNumberiPhone
                                                               value:[[CNPhoneNumber alloc] initWithStringValue:((SBSDKPhoneNumberQRCode *) self.code).phoneNumber]]];
        contact = newContact;
    } else  {
        return;
    }
    
    CNContactViewController *addContactVC = [CNContactViewController viewControllerForNewContact:contact];
    addContactVC.delegate = self;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:addContactVC];
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)copyToClipboardAndDismiss {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.code.stringValue;
    [self dismiss];
}

- (void)openExternalLink {
    [self.code openExternally];
}

- (void)sendSMS {
    if([MFMessageComposeViewController canSendText]) {
        SBSDKShortMessageQRCode *code = (SBSDKShortMessageQRCode *) self.code;
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        controller.messageComposeDelegate = self;
        controller.body = code.body;
        controller.recipients = code.recipients;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)addEvent {
    EKEventStore *store = SBSDKEventQRCode.sharedEventStore;
    SBSDKEventQRCode *code = (SBSDKEventQRCode *) self.code;
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
        if (!granted) { return; }
        [store saveEvent:code.event span:EKSpanThisEvent commit:YES error:nil];
    }];
}

- (void)dismiss {
    [self.delegate qrDescriptionViewControllerWillDissmiss:self];
    for (NSLayoutConstraint *constraint in self.bubbleConstraints) {
        constraint.constant = constraint.constant * 2;
    }
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.view layoutIfNeeded];
        self.mainStackView.alpha = 0.0;
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (IBAction)didTapView:(id)sender {
    [self dismiss];
}

- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(CNContact *)contact {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)upperButtonTapped:(id)sender {
    [self copyToClipboardAndDismiss];
}

- (IBAction)lowerButtonTapped:(id)sender {
    if ([self.code isKindOfClass:[SBSDKContactQRCode class]]) {
        [self addContact];
    } else if ([self.code isKindOfClass:[SBSDKShortMessageQRCode class]]) {
        [self sendSMS];
    } else if ([self.code isKindOfClass:[SBSDKWebURLQRCode class]]) {
        [self openExternalLink];
    } else if ([self.code isKindOfClass:[SBSDKMailMessageQRCode class]]) {
        [self openExternalLink];
    } else if ([self.code isKindOfClass:[SBSDKEventQRCode class]]) {
        [self addEvent];
    } else if ([self.code isKindOfClass:[SBSDKPhoneNumberQRCode class]]) {
        [self addContact];
    } else if ([self.code isKindOfClass:[SBSDKLocationQRCode class]]) {
        [self openExternalLink];
    }
}
@end
