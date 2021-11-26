//
//  AppDelegate.m
//  ScanbotSDKDemo
//
//  Created by Sebastian Husche on 21.04.15.
//  Copyright (c) 2015 doo GmbH. All rights reserved.
//

#import "AppDelegate.h"
#import "ScanbotSDKInclude.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // TODO Add your Scanbot SDK license here:
    //[ScanbotSDK setLicense: @"YOUR_SCANBOT_SDK_LICENSE_KEY"];
    [ScanbotSDK setLicense:
    @"es1863Een2nSot1SmxyVqcEXJgTZXB"
    "bkNznctG6B8kNj/0Dn1HOhyWxl02OY"
    "jKqKm6mVQG6l/pet9usBiNnuzn3Iej"
    "Ap/ICsmWYZ8d4wm72Br9OOor0YF5hF"
    "yiuXUvKvZA1ys8jMvEf1S3+2C/7AR1"
    "4/24VzdJsLYL1NnLSqGLappgCaTbrm"
    "BJlJBP/dCi+AG8Uizp8OQ7aU7tQjii"
    "joNUbcBUhwVFIo2uBzK/gvptSqewDh"
    "v2q1SrXO/CQtjrc0yIX1C+aoZ50FTh"
    "gbul1FmfHVNM3fqyiz8YdVxW92hKUa"
    "ZRlf+MLVW3aIg3HlU/O51tzEaqGJdr"
    "x0JYG2QKztaA==\nU2NhbmJvdFNESw"
    "ppby5zY2FuYm90LmV4YW1wbGUuc2Rr"
    "Lmlvcy5jbGFzc2ljCjE2Mzg2NjIzOT"
    "kKODM4ODYwNwox\n"];// TODO: Remove before submitting PR
    
    // Setup the default license failure handler. In case of expired license or expired trial period it will present an alert and terminate the app.
    // See also [ScanbotSDK setLicenseFailureHandler:handler]; to setup a custom handler.
    [ScanbotSDK setupDefaultLicenseFailureHandler];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
