//
//  CameraDeviceObjcViewController.m
//  ScanbotSDK Examples
//
//  Created by Seifeddine Bouzid on 01.12.22.
//

#import "CameraDeviceObjcViewController.h"
@import ScanbotSDK;

@interface CameraDeviceObjcViewController ()

@end

@implementation CameraDeviceObjcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Get all the availables camera devices.
    NSArray<SBSDKCameraDevice*> *availablesDevices = [SBSDKCameraDevice availableDevices];
    
    // Get all the availables back camera devices.
    NSArray<SBSDKCameraDevice*> *availablesBackDevices = [SBSDKCameraDevice availableDevicesForPosition:SBSDKCameraDevicePositionBack];
    
    // Get all the desired camera by providing the type and position. 
    NSArray<SBSDKCameraDevice*> *availableTripeCameraBackDevices = [SBSDKCameraDevice availableDevicesForType:SBSDKCameraDeviceTypeTriple 
                                                                                                  andPosition:SBSDKCameraDevicePositionBack];
    
    // Get the default back facing camera.
    SBSDKCameraDevice *defaultBackCamera = [SBSDKCameraDevice defaultBackFacingCamera];
    
    // Get the default front facing camera.  
    SBSDKCameraDevice *defaultFrontCamera = [SBSDKCameraDevice defaultFrontFacingCamera];
    
    // Get the first triple back camera and create scanner components.
    SBSDKCameraDevice *tripleCamera = availableTripeCameraBackDevices.firstObject;
    if (tripleCamera != nil) {
        [self createRTUUIScanner:tripleCamera];
        [self createClassicalScanner:tripleCamera];
    }
}

- (void)createRTUUIScanner:(SBSDKCameraDevice *)device {
    
    // Create the camera configuration.
    SBSDKUICameraConfiguration *cameraConfig = [[SBSDKUICameraConfiguration alloc] init];
    
    // Assign the device to the camera configuration.
    cameraConfig.camera = device;
    
    // Assemble the scanner configuration and pass the camera configuration.
    SBSDKUIDocumentScannerConfiguration *configuration =
    [[SBSDKUIDocumentScannerConfiguration alloc] initWithUiConfiguration:[SBSDKUIDocumentScannerUIConfiguration new]
                                                       textConfiguration:[SBSDKUIDocumentScannerTextConfiguration new]
                                                   behaviorConfiguration:[SBSDKUIDocumentScannerBehaviorConfiguration new] 
                                                     cameraConfiguration:cameraConfig];
    
    // Create the RTU-UI scanner, passing the scanner configuration.
    SBSDKUIDocumentScannerViewController *scanner = 
    [SBSDKUIDocumentScannerViewController createNewWithConfiguration:configuration andDelegate:nil];
}

- (void)createClassicalScanner:(SBSDKCameraDevice *)device {
    
    // Create the classical scanner.
    SBSDKDocumentScannerViewController *scanner 
    = [[SBSDKDocumentScannerViewController alloc] initWithParentViewController:self parentView:self.view delegate:nil];
    
    // Assign the device to the scanner.
    scanner.cameraDevice = device;
}

@end
