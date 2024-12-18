# Scanbot Barcode & Document Scanning Example App for iOS

This example app shows how to integrate the [Scanbot Barcode Scanner SDK](https://scanbot.io/developer/ios-barcode-scanner-sdk/), [Scanbot Document Scanner SDK](https://scanbot.io/developer/ios-document-scanner/), and [Scanbot Data Capture SDK](https://scanbot.io/developer/ios-data-capture/) for iOS.

## What is the Scanbot SDK?

The Scanbot SDK lets you integrate barcode & document scanning, as well as data extraction functionalities, into your mobile apps and website. It contains different modules that are licensable for an annual fixed price. For more details, visit our website https://scanbot.io.


## Trial License

The Scanbot SDK will run without a license for one minute per session!

After the trial period has expired, all SDK functions and UI components will stop working. You have to restart the app to get another one-minute trial period.

To try the Scanbot SDK without a one-minute limit, you can get a free “no-strings-attached” trial license. Please submit the [Trial License Form](https://scanbot.io/trial/) on our website.

## Free Developer Support

We provide free "no-strings-attached" developer support for the implementation & testing of the Scanbot SDK.
If you encounter technical issues with integrating the Scanbot SDK or need advice on choosing the appropriate
framework or features, please visit our [Support Page](https://docs.scanbot.io/support/).

## Documentation
- [Developer Guide](https://docs.scanbot.io/document-scanner-sdk/ios/introduction/)
- [API Docs](https://scanbotsdk.github.io/documentation/ios/)


## How to run this example app?

- Clone this repository to a local folder
- Open `ClassicComponentsExample.xcodeproj` with Xcode, build and run, a build script will automatically download ScanbotSDK to your project folder if needed

- In case you do not want to automatically download the SDK in the Demo app's target, remove the dependency to the 'Download ScanbotSDK' aggregate target and perform the following steps:
  * [Download the latest Scanbot SDK for iOS from our website](https://docs.scanbot.io/document-scanner-sdk/ios/getting-started/)
  * Unzip the downloaded zip file and copy the extracted `ScanbotSDK` folder to your local example app folder (`scanbot-sdk-example-ios/ScanbotSDK`)
  * For Classical UI components open `ClassicComponentsExample.xcodeproj` with Xcode, build and run
  * For Document Ready-To-Use UI open `DocumentScannerRTUUIExample.xcodeproj` with Xcode, build and run
  * For Data Capture Ready-To-Use UI open `DataCaptureRTUUIExample.xcodeproj` with Xcode, build and run
  * For SwiftUI Components open `SwiftUIComponentsExample.xcodeproj` with Xcode, build and run
