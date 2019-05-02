//
//  WorkflowFactory.h
//  ReadyToUseUIDemo
//
//  Created by Sebastian Husche on 20.11.18.
//  Copyright © 2019 doo GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
@import ScanbotSDK;

NS_ASSUME_NONNULL_BEGIN

@interface WorkflowFactory : NSObject

+ (NSArray<SBSDKUIWorkflow*>*)allWorkflows;

+ (SBSDKUIWorkflow *)idCard;
+ (SBSDKUIWorkflow *)idCardOrPassport;
+ (SBSDKUIWorkflow *)disabilityCertificate;
+ (SBSDKUIWorkflow *)qrCodeAndDocument;
+ (SBSDKUIWorkflow *)payform;

@end

NS_ASSUME_NONNULL_END
