# Document scanner SDK and MRZ, QR code, barcode scanner

## Scanbot SDK example apps for iOS

These example apps show how to integrate the [Scanbot SDK](https://scanbot.io) for iOS.


## What is Scanbot SDK?

Scanbot SDK for iOS is a simple to use high level API, providing a collection of classes and functions
for scanning and processing documents from your mobile device's camera or other image sources like your photo library.

Boost your iOS app with the powerful and convenient document scanning and processing features that also drive the #1
scanning app in the iOS app store: Scanbot Pro.

Scanbot SDK consists of a bunch of modules, each individually licensable or avalaible in license packages.

Currently the following modules are available:
- Document detection in digital images
- User interface for guided, automatic document scanning using the document detection module
- Image processing for rotating, cropping, filtering and perspective correction, optimized for the needs of document
scanning
- PDF creation, merge a collection of processed or unprocessed document images and write them into a PDF document with
one page per image
- Optical character recognition, recognize text in document images and create searchable PDF documents with
selectable text
- Payform recognition, detect and recognize SEPA payforms on images and extract the important data fields via OCR
- Beta software for invoice, cheque and credit card recognition

Scanbot SDK supports iOS 9 and higher.

If you need further information or are interested in licensing Scanbot SDK please contact us via sdk@scanbot.io
or visit our website https://scanbot.io



## Documentation

[View Scanbot SDK Online documentation](https://scanbotsdk.github.io/documentation/ios/)



## How to run this example app?

- Clone this repository to a local folder
- Open `ScanbotSDKDemo.xcodeproj` with Xcode, build and run, a build script will automatically download ScanbotSDK to your project folder if needed

- In case you don't want to automatically download the SDK in the Demo apps target remove the dependency to the 'Download ScanbotSDK' aggregate target and perform the following steps:
  * [Download the latest Scanbot SDK for iOS from our website](https://scanbot.io/en/sdk/documentation)
  * Unzip the downloaded zip file and copy the extracted `ScanbotSDK` folder to your local example app folder (`scanbot-sdk-example-ios/ScanbotSDK`)
  * Open `ScanbotSDKDemo.xcodeproj` with Xcode, build and run


## Please note

The Scanbot SDK will run without a license for one minute per session!

After the trial period is over all Scanbot SDK functions as well as the UI components (like Document Scanner UI) will stop working or may be terminated.
You have to restart the app to get another trial period.

To get an unrestricted "no-strings-attached" 30 day trial license, please submit the [Trial License Form](https://scanbot.io/en/sdk/demo/trial) on our website.
