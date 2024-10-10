//
//  SoundControllerObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 06.12.22.
//

#import "SoundControllerObjcViewController.h"
@import ScanbotSDK;

@interface SoundControllerObjcViewController ()

@end

@implementation SoundControllerObjcViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Initialize the sound controller.
    SBSDKSoundController *soundController = [[SBSDKSoundController alloc] init];
    
    // Play the beep sound and vibrate after 2 seconds.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        // Beep.
        [soundController playBleepSound];

        // Vibration.
        [soundController vibrate];
    });
    

    // Play a sound from a custom url and vibrate after 3 seconds.
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"sound" withExtension:@"m4a"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // Play custom sound.
        [soundController playCustomSoundFromURL:url];
        
        // Vibrate.
        [soundController vibrate];
    });
}
@end
