//
//  WorkflowFactory.h
//  SBSDK Internal Demo
//
//  Created by Sebastian Husche on 20.11.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
@import ScanbotSDK;

NS_ASSUME_NONNULL_BEGIN

@interface WorkflowFactory : NSObject

+ (NSArray<SBSDKUIWorkflow*>*)allWorkflows;

+ (SBSDKUIWorkflow *)germanIDCard;
+ (SBSDKUIWorkflow *)ukrainianPassport;
+ (SBSDKUIWorkflow *)disabilityCertificate;
+ (SBSDKUIWorkflow *)blackWhiteDocument;
+ (SBSDKUIWorkflow *)qrCodeAndDocument;

+ (SBSDKUIWorkflowStep *)qrCodeStep;
+ (SBSDKUIWorkflowStep *)documentStep;

@end

NS_ASSUME_NONNULL_END
