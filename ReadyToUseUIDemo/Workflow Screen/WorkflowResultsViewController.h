//
//  WorkflowResultsViewController.h
//  SBSDK Internal Demo
//
//  Created by Sebastian Husche on 20.11.18.
//  Copyright © 2018 doo GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
@import ScanbotSDK;

NS_ASSUME_NONNULL_BEGIN

@interface WorkflowResultsViewController : UIViewController

@property(nonatomic, readonly) NSArray<SBSDKUIWorkflowStepResult*>* workflowResults;

+ (instancetype)instantiateWith:(NSArray<SBSDKUIWorkflowStepResult*>*) workflowResults;

@end

NS_ASSUME_NONNULL_END
